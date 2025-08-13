//
//  SwiftUIView.swift
//  SwiSekai
//
//  Created by Agustio Maitimu on 12/08/25.
//

import SwiftUI
import HighlightSwift

struct ContentBlockView: View {
	let blocks: [ContentBlock]
	let highlight = Highlight()
	@State private var buttonText: String = "Copy"
	
	var body: some View {
		List(blocks) { block in
			switch block {
			case .explanation(let text):
				Text(text.toStyledTaggedString())
					.padding(.vertical, 4)
					.listRowSeparator(.hidden)
				
			case .snippet(let code):
				ZStack(alignment: .topTrailing) {
					Text(code)
						.font(.system(.body, design: .monospaced))
						.frame(maxWidth: .infinity, alignment: .leading)
						.padding()
						.background(Color.gray.opacity(0.2))
						.cornerRadius(8)
						.textSelection(.enabled)
					
					Button(buttonText) {
						copyToClipboard(code: code)
					}
					.padding(.horizontal, 8)
					.padding(.vertical, 4)
					.background(.secondary.opacity(0.4))
					.cornerRadius(4)
					.padding(8)
					.listRowSeparator(.hidden)
				}
				
			case .multipleChoice(let question, let options, let answer):
				MultipleChoiceView(
					question: question,
					options: options,
					correctAnswer: answer
				)
				.listRowSeparator(.hidden)
				
			case .fillBlank:
				Text("[Fill in the Blank Question UI Here]")
					.foregroundColor(.gray)
					.listRowSeparator(.hidden)
				
			case .heading1(let text):
				Text(text)
					.font(.largeTitle)
					.bold()
					.listRowSeparator(.hidden)
				
			case .heading2(let text):
				Text(text)
					.font(.title)
					.bold()
					.listRowSeparator(.hidden)
				
			case .heading3(let text):
				Text(text)
					.font(.title2)
					.bold()
					.listRowSeparator(.hidden)
				
			case .heading4(let text):
				Text(text)
					.font(.title3)
					.bold()
					.listRowSeparator(.hidden)
				
			case .heading5(let text):
				Text(text)
					.font(.headline)
					.bold()
					.listRowSeparator(.hidden)
				
			case .heading6(let text):
				Text(text)
					.font(.subheadline)
					.bold()
					.listRowSeparator(.hidden)
				
			case .orderedList(let items):
				VStack(alignment: .leading) {
					ForEach(items.indices, id: \.self) { index in
						HStack(alignment: .top) {
							Text("\(index + 1).")
							Text(items[index])
						}
					}
				}
				.listRowSeparator(.hidden)
				
			case .unorderedList(let items):
				VStack(alignment: .leading) {
					ForEach(items, id: \.self) { item in
						HStack(alignment: .top) {
							Text("•")
							Text(item)
						}
					}
				}
				.listRowSeparator(.hidden)
			}
			
		}
		.listStyle(.plain)
	}
	
	private func copyToClipboard(code: String) {
		NSPasteboard.general.clearContents()
		NSPasteboard.general.setString(code, forType: .string)
		
		self.buttonText = "Copied!"
		DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
			self.buttonText = "Copy"
		}
	}
}

extension String {
	func toStyledTaggedString() -> AttributedString {
		do {
			let regex = try NSRegularExpression(pattern: "(\\*\\*|==|\\*)(.*?)\\1", options: [])
			
			var attributedString = AttributedString(self)
			
			let matches = regex.matches(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count))
			
			for match in matches.reversed() {
				guard let fullRange = Range(match.range, in: self) else { continue }
				guard let markerRange = Range(match.range(at: 1), in: self) else { continue }
				guard let contentRange = Range(match.range(at: 2), in: self) else { continue }
				
				let marker = String(self[markerRange])
				let content = String(self[contentRange])
				
				var styledPart = AttributedString(content)
				
				switch marker {
				case "**":
					styledPart.font = .body.bold()
				case "*":
					styledPart.font = .body.italic()
				case "==":
					styledPart.backgroundColor = .yellow.opacity(0.3)
				default:
					break
				}
				
				if let rangeToReplace = Range(fullRange, in: attributedString) {
					attributedString.replaceSubrange(rangeToReplace, with: styledPart)
				}
			}
			return attributedString
		} catch {
			return AttributedString(self)
		}
	}
}

//#Preview {
//    ContentBlockView()
//}
