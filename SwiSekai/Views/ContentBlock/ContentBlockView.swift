//
//  SwiftUIView.swift
//  SwiSekai
//
//  Created by Agustio Maitimu on 12/08/25.
//

import SwiftUI
import Highlightr


class HighlightrManager {
    let highlightr: Highlightr?

    init() {
        highlightr = Highlightr()
        highlightr?.setTheme(to: "xcode-dark")
    }

    func highlight(_ code: String, as language: String) -> AttributedString {
        if let highlightedNSAttributedString = highlightr?.highlight(code, as: language) {
            return AttributedString(highlightedNSAttributedString)
        }
        return AttributedString(code)
    }
}

// Main View
struct ContentBlockView: View {
    let blocks: [ContentBlock]
    private let highlightrManager = HighlightrManager()

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(blocks) { block in
                switch block {
                case .heading1(let text):
                    HeadingView(text: text, level: 1)
                case .heading2(let text):
                    HeadingView(text: text, level: 2)
                case .heading3(let text):
                    HeadingView(text: text, level: 3)
                case .heading4(let text):
                    HeadingView(text: text, level: 4)
                case .heading5(let text):
                    HeadingView(text: text, level: 5)
                case .heading6(let text):
                    HeadingView(text: text, level: 6)
                case .explanation(let text):
                    ParagraphView(text: text)
                case .snippet(let code):
                    SnippetView(code: code, highlightrManager: highlightrManager)
                case .orderedList(let items):
                    ListView(items: items, isOrdered: true)
                case .unorderedList(let items):
                    ListView(items: items, isOrdered: false)
                case .fillBlank:
                    FillBlankView()
                }
            }
        }
		.background(.mainBackground)
    }
}

// MARK: - Heading Views

struct HeadingView: View {
    let text: String
    let level: Int

    var body: some View {
        let headingFont = fontForLevel()
        
        Text(text.toStyledTaggedString(baseFont: headingFont.bold()))
            .foregroundColor(.white.opacity(0.95))
            .padding(.vertical, level > 2 ? 4 : 8)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func fontForLevel() -> Font {
        switch level {
        case 1: return .largeTitle
        case 2: return .title
        case 3: return .title2
        case 4: return .title3
        case 5: return .headline
        default: return .subheadline
        }
    }
}

// MARK: - Paragraph Views

struct ParagraphView: View {
    let text: String
    
    var body: some View {
        Text(styledAttributedText)
            .foregroundColor(Color.white)
            .padding(.top, 4)
            .padding(.bottom, 16)
            .lineSpacing(12)
            .fixedSize(horizontal: false, vertical: true)
    }
    
    private var styledAttributedText: AttributedString {
        var attributedText = text.toStyledTaggedString()
        attributedText.font = .system(size: 16, weight: .light)
        return attributedText
    }
}

// MARK: - Snippet Views

struct SnippetView: View {
    let code: String
    let highlightrManager: HighlightrManager
    @State private var buttonText: String = "Copy"

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Text(highlightrManager.highlight(code, as: "swift"))
                .font(.system(.body, design: .monospaced))
                .lineSpacing(8)
                .lineLimit(nil) // <-- ADD THIS LINE
                .frame(maxWidth: .infinity, alignment: .leading)
                .textSelection(.enabled)
                .padding()
                .background(Color("SnippetBackgroundColor"))
                .cornerRadius(12)
            
            Button(action: copyToClipboard) {
                HStack(spacing: 5) {
                    Image(systemName: "doc.on.doc.fill")
                    Text(buttonText)
                }
            }
            .font(.caption)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .foregroundColor(.white)
            .cornerRadius(6)
            .padding(12)
            .animation(.easeInOut(duration: 0.2), value: buttonText)
        }
        .frame(maxWidth: .infinity)
    }

    private func copyToClipboard() {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(code, forType: .string)
        
        self.buttonText = "Copied!"
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.buttonText = "Copy"
        }
    }
}

// MARK: - List Views

struct ListView: View {
    let items: [String]
    let isOrdered: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                HStack(alignment: .top, spacing: 12) {
                    Text(isOrdered ? "\(index + 1)." : "•")
                        .frame(minWidth: 20, alignment: .leading)
                    Text(item.toStyledTaggedString())
                }
            }
        }
        .foregroundColor(Color(white: 0.8))
        .padding(.leading, 10)
    }
}

// MARK: - Fill Blank Views

struct FillBlankView: View {
    var body: some View {
        Text("[Fill in the Blank Question UI Here]")
            .foregroundColor(.gray)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.gray.opacity(0.15))
            .cornerRadius(8)
    }
}

// MARK: - String Extension (Corrected)
extension String {
    // Add the baseFont parameter with a default value
    func toStyledTaggedString(baseFont: Font = .body) -> AttributedString {
        do {
            let regex = try NSRegularExpression(pattern: "(\\*\\*|==|\\*)(.*?)\\1", options: [])

            var attributedString = AttributedString(self)
            // Use the passed-in font as the base
            attributedString.font = baseFont

            let matches = regex.matches(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count))

            for match in matches.reversed() {
                guard let fullRange = Range(match.range, in: self),
                      let markerRange = Range(match.range(at: 1), in: self),
                      let contentRange = Range(match.range(at: 2), in: self) else { continue }
                
                let marker = String(self[markerRange])
                let content = String(self[contentRange])
                
                var styledPart = AttributedString(content)
                // Also set the base font for the styled part
                styledPart.font = baseFont
                
                switch marker {
                case "**":
                    // Use the AttributedString's own modifiers
                    styledPart.inlinePresentationIntent = .stronglyEmphasized
                    styledPart.foregroundColor = Color("KeywordColor")
                case "*":
                    // Use the AttributedString's own modifiers
                    styledPart.inlinePresentationIntent = .emphasized
                case "==":
                    styledPart.backgroundColor = Color.yellow.opacity(0.4)
                    styledPart.foregroundColor = .white
                default:
                    break
                }
                
                if let rangeToReplace = Range(fullRange, in: attributedString) {
                    attributedString.replaceSubrange(rangeToReplace, with: styledPart)
                }
            }
            return attributedString
        } catch {
            // Also apply the base font in the error case
            var attributedString = AttributedString(self)
            attributedString.font = baseFont
            return attributedString
        }
    }
}
