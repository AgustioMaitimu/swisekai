//
//  BotMessageView.swift
//  SwiSekai
//
//  Created by Ryan Hangralim on 24/08/25.
//

import SwiftUI

enum MessageContent: Hashable {
    case text(String)
    case code(String)
}

struct BotMessageView: View {
    let contents: [MessageContent]

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 8) {
                    Text("Taylor")
                        .fontWeight(.semibold)
                    Text("08.58")
                }
                .font(.caption)
                .foregroundColor(.secondary)
                
                // Loop through each content block and display it
                ForEach(contents, id: \.self) { content in
                    switch content {
                    case .text(let message):
                        // Display a standard text block
                        Text(message)
                            .multilineTextAlignment(.leading)
                        
                    case .code(let snippet):
                        // Display code snippet view
                        SnippetView(code: snippet, highlightrManager: HighlightrManager())
                    }
                }
                
                // This footer part remains the same
                Text("Ask anything about var vs let, optionals, or type inference.")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color("ChatbotMessageColor"))
            .foregroundColor(.white)
            .cornerRadius(15)
            .frame(maxWidth: 600, alignment: .leading)
            
            Spacer()
        }
    }
}

func parseBotResponse(rawText: String) -> [MessageContent] {
    var result: [MessageContent] = []
    let delimiter = "```"
    let components = rawText.components(separatedBy: delimiter)
    
    for (index, part) in components.enumerated() {
        let trimmedPart = part.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Skip any empty strings that result from splitting
        if trimmedPart.isEmpty {
            continue
        }
        
        // Even-indexed components are regular text
        if index % 2 == 0 {
            result.append(.text(trimmedPart))
        }
        // Odd-indexed components are code snippets
        else {
            if let firstNewline = trimmedPart.firstIndex(of: "\n") {
                let code = String(trimmedPart[trimmedPart.index(after: firstNewline)...])
                result.append(.code(code.trimmingCharacters(in: .whitespacesAndNewlines)))
            } else {
                result.append(.code(trimmedPart))
            }
        }
    }
    
    return result
}

#Preview {
    BotMessageView(contents: parseBotResponse(rawText: """
        In Swift, you use `var` for variables that can change and `let` for constants that cannot.

        Here is an example of a variable:
        ```swift
        var greeting = "Hello, playground"
        greeting = "Hello, world" // This is allowed
        ```
        And here is a constant. Trying to change it will cause an error.
        ```swift
        let pi = 3.14159
        // pi = 3.14 // This would be a compile-time error
        ```
        This distinction helps you write safer, more predictable code.
        """))
}
