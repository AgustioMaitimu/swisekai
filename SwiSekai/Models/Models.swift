//
//  Models.swift
//  SwiSekai
//
//  Created by Agustio Maitimu on 12/08/25.
//

import Foundation
import Yams

struct ModuleCollection: Codable {
	let modules: [Module]
}

struct ProjectCollection: Codable {
	let projects: [Project]
}

struct Module: Codable, Identifiable {
	let id: UUID
	let module_name: String
	let module_blocks: [ContentBlock]
}

struct Project: Codable, Identifiable {
	let id: UUID
	let project_name: String
	let project_blocks: [ContentBlock]
	let level_prerequisite: Int
}

enum ContentBlock: Codable, Identifiable {
	case explanation(text: String)
	case snippet(code: String)
	case multipleChoice(question: String, options: [String], answer: String)
	case fillBlank(prose: String, answer: String)
	
	var id: String {
		switch self {
		case .explanation(let text):
			return "exp-" + text
		case .snippet(let code):
			return "snip-" + code
		case .multipleChoice(let question, _, _):
			return "mc-" + question
		case .fillBlank(let prose, _):
			return "fb-" + prose
		}
	}
	
	private enum CodingKeys: String, CodingKey {
		case type, content
	}
	
	private enum ContentKeys: String, CodingKey {
		case text, code, question, options, answer, prose
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		let type = try container.decode(String.self, forKey: .type)
		let contentContainer = try container.nestedContainer(keyedBy: ContentKeys.self, forKey: .content)
		
		switch type {
		case "explanation":
			let text = try contentContainer.decode(String.self, forKey: .text)
			self = .explanation(text: text)
		case "snippet":
			let code = try contentContainer.decode(String.self, forKey: .code)
			self = .snippet(code: code)
		case "multipleChoice":
			let question = try contentContainer.decode(String.self, forKey: .question)
			let options = try contentContainer.decode([String].self, forKey: .options)
			let answer = try contentContainer.decode(String.self, forKey: .answer)
			self = .multipleChoice(question: question, options: options, answer: answer)
		case "fillBlank":
			let prose = try contentContainer.decode(String.self, forKey: .prose)
			let answer = try contentContainer.decode(String.self, forKey: .answer)
			self = .fillBlank(prose: prose, answer: answer)
		default:
			throw DecodingError.dataCorruptedError(forKey: .type, in: container, debugDescription: "Invalid content block type")
		}
	}
	
	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		var contentContainer = container.nestedContainer(keyedBy: ContentKeys.self, forKey: .content)
		
		switch self {
		case .explanation(let text):
			try container.encode("explanation", forKey: .type)
			try contentContainer.encode(text, forKey: .text)
		case .snippet(let code):
			try container.encode("snippet", forKey: .type)
			try contentContainer.encode(code, forKey: .code)
		case .multipleChoice(let question, let options, let answer):
			try container.encode("multipleChoice", forKey: .type)
			try contentContainer.encode(question, forKey: .question)
			try contentContainer.encode(options, forKey: .options)
			try contentContainer.encode(answer, forKey: .answer)
		case .fillBlank(let prose, let answer):
			try container.encode("fillBlank", forKey: .type)
			try contentContainer.encode(prose, forKey: .prose)
			try contentContainer.encode(answer, forKey: .answer)
		}
	}
}
