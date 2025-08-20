// SwiSekai/Models/Models.swift

import Foundation
import Yams

struct ChapterCollection: Codable {
    let chapters: [Chapter]
}

struct Chapter: Codable {
    let chapterName: String
    let modules: [Module]
    let finalReview: FinalReview
}

struct Module: Codable, Identifiable {
    let id: UUID
    let moduleName: String
    let moduleNumber: Int
    let contentBlocks: [ContentBlock]
    let multipleChoice: [MultipleChoice]
    
    enum CodingKeys: String, CodingKey {
        case id
        case moduleName = "module_name"
        case moduleNumber = "module_number"
        case contentBlocks = "content_blocks"
        case multipleChoice = "multiple_choice"
    }
}

struct FinalReview: Codable {
    let contentBlocks: [ContentBlock]
    enum CodingKeys: String, CodingKey {
        case contentBlocks = "content_blocks"
    }
}

struct ProjectCollection: Codable {
    let projects: [Project]
}

struct ModuleCollection: Codable {
    let modules: [Module]
    
    init(modules: [Module]) {
        self.modules = modules
    }
}

struct Project: Codable, Identifiable {
    let id: UUID
    let projectName: String
    let contentBlocks: [ContentBlock]
    let levelPrerequisite: Int
    let projectDifficulty: String
    let projectDescription: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case projectName = "project_name"
        case contentBlocks = "content_blocks"
        case levelPrerequisite = "level_prerequisite"
        case projectDifficulty = "project_difficulty"
        case projectDescription = "project_description"
    }
}

struct MultipleChoice: Codable, Identifiable {
    let id = UUID()
    let question: String
    let options: [String]
    let answer: String
}



enum ContentBlock: Codable, Identifiable {
    case explanation(text: String)
    case snippet(code: String)
    case fillBlank(prose: String, answer: String)
    case heading1(text: String)
    case heading2(text: String)
    case heading3(text: String)
    case heading4(text: String)
    case heading5(text: String)
    case heading6(text: String)
    case orderedList(items: [String])
    case unorderedList(items: [String])
    
    var id: String {
        switch self {
        case .explanation(let text):
            return "exp-" + text
        case .snippet(let code):
            return "snip-" + code
        case .fillBlank(let prose, _):
            return "fb-" + prose
        case .heading1(let text):
            return "h1-" + text
        case .heading2(let text):
            return "h2-" + text
        case .heading3(let text):
            return "h3-" + text
        case .heading4(let text):
            return "h4-" + text
        case .heading5(let text):
            return "h5-" + text
        case .heading6(let text):
            return "h6-" + text
        case .orderedList(let items):
            return "ol-" + items.joined()
        case .unorderedList(let items):
            return "ul-" + items.joined()
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case type, content
    }
    
    private enum ContentKeys: String, CodingKey {
        case text, code, question, options, answer, prose, items
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)
        
        switch type {
        case "explanation":
            let contentContainer = try container.nestedContainer(keyedBy: ContentKeys.self, forKey: .content)
            let text = try contentContainer.decode(String.self, forKey: .text)
            self = .explanation(text: text)
        case "snippet":
            let contentContainer = try container.nestedContainer(keyedBy: ContentKeys.self, forKey: .content)
            let code = try contentContainer.decode(String.self, forKey: .code)
            self = .snippet(code: code)
        case "fillBlank":
            let contentContainer = try container.nestedContainer(keyedBy: ContentKeys.self, forKey: .content)
            let prose = try contentContainer.decode(String.self, forKey: .prose)
            let answer = try contentContainer.decode(String.self, forKey: .answer)
            self = .fillBlank(prose: prose, answer: answer)
        case "heading1":
            let contentContainer = try container.nestedContainer(keyedBy: ContentKeys.self, forKey: .content)
            let text = try contentContainer.decode(String.self, forKey: .text)
            self = .heading1(text: text)
        case "heading2":
            let contentContainer = try container.nestedContainer(keyedBy: ContentKeys.self, forKey: .content)
            let text = try contentContainer.decode(String.self, forKey: .text)
            self = .heading2(text: text)
        case "heading3":
            let contentContainer = try container.nestedContainer(keyedBy: ContentKeys.self, forKey: .content)
            let text = try contentContainer.decode(String.self, forKey: .text)
            self = .heading3(text: text)
        case "heading4":
            let contentContainer = try container.nestedContainer(keyedBy: ContentKeys.self, forKey: .content)
            let text = try contentContainer.decode(String.self, forKey: .text)
            self = .heading4(text: text)
        case "heading5":
            let contentContainer = try container.nestedContainer(keyedBy: ContentKeys.self, forKey: .content)
            let text = try contentContainer.decode(String.self, forKey: .text)
            self = .heading5(text: text)
        case "heading6":
            let contentContainer = try container.nestedContainer(keyedBy: ContentKeys.self, forKey: .content)
            let text = try contentContainer.decode(String.self, forKey: .text)
            self = .heading6(text: text)
        case "orderedList":
            let contentContainer = try container.nestedContainer(keyedBy: ContentKeys.self, forKey: .content)
            let items = try contentContainer.decode([String].self, forKey: .items)
            self = .orderedList(items: items)
        case "unorderedList":
            let contentContainer = try container.nestedContainer(keyedBy: ContentKeys.self, forKey: .content)
            let items = try contentContainer.decode([String].self, forKey: .items)
            self = .unorderedList(items: items)
        default:
            throw DecodingError.dataCorruptedError(forKey: .type, in: container, debugDescription: "Invalid content block type")
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case .explanation(let text):
            try container.encode("explanation", forKey: .type)
            var contentContainer = container.nestedContainer(keyedBy: ContentKeys.self, forKey: .content)
            try contentContainer.encode(text, forKey: .text)
        case .snippet(let code):
            try container.encode("snippet", forKey: .type)
            var contentContainer = container.nestedContainer(keyedBy: ContentKeys.self, forKey: .content)
            try contentContainer.encode(code, forKey: .code)
        case .fillBlank(let prose, let answer):
            try container.encode("fillBlank", forKey: .type)
            var contentContainer = container.nestedContainer(keyedBy: ContentKeys.self, forKey: .content)
            try contentContainer.encode(prose, forKey: .prose)
            try contentContainer.encode(answer, forKey: .answer)
        case .heading1(let text):
            try container.encode("heading1", forKey: .type)
            var contentContainer = container.nestedContainer(keyedBy: ContentKeys.self, forKey: .content)
            try contentContainer.encode(text, forKey: .text)
        case .heading2(let text):
            try container.encode("heading2", forKey: .type)
            var contentContainer = container.nestedContainer(keyedBy: ContentKeys.self, forKey: .content)
            try contentContainer.encode(text, forKey: .text)
        case .heading3(let text):
            try container.encode("heading3", forKey: .type)
            var contentContainer = container.nestedContainer(keyedBy: ContentKeys.self, forKey: .content)
            try contentContainer.encode(text, forKey: .text)
        case .heading4(let text):
            try container.encode("heading4", forKey: .type)
            var contentContainer = container.nestedContainer(keyedBy: ContentKeys.self, forKey: .content)
            try contentContainer.encode(text, forKey: .text)
        case .heading5(let text):
            try container.encode("heading5", forKey: .type)
            var contentContainer = container.nestedContainer(keyedBy: ContentKeys.self, forKey: .content)
            try contentContainer.encode(text, forKey: .text)
        case .heading6(let text):
            try container.encode("heading6", forKey: .type)
            var contentContainer = container.nestedContainer(keyedBy: ContentKeys.self, forKey: .content)
            try contentContainer.encode(text, forKey: .text)
        case .orderedList(let items):
            try container.encode("orderedList", forKey: .type)
            var contentContainer = container.nestedContainer(keyedBy: ContentKeys.self, forKey: .content)
            try contentContainer.encode(items, forKey: .items)
        case .unorderedList(let items):
            try container.encode("unorderedList", forKey: .type)
            var contentContainer = container.nestedContainer(keyedBy: ContentKeys.self, forKey: .content)
            try contentContainer.encode(items, forKey: .items)
        }
    }
}
