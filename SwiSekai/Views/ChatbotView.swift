//
//  ChatbotView.swift
//  SwiSekai
//
//  Created by Ryan Hangralim on 24/08/25.
//

import SwiftUI

struct ChatbotSidebarView: View {
    @Binding var isShowing: Bool
    let botResponse = """
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
        """
    
    
    var body: some View {
        VStack(spacing: 0) {
            HStack{
                Button(action: {
                    withAnimation {
                        isShowing = false
                    }
                }) {
                    Image(systemName: "xmark")
                        .font(.title)
                }
                .buttonStyle(.plain)
                
                Spacer()
            }
            .padding(.top)
            .padding(.leading)
            
            HeaderView()

            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    UserMessageView(text: "Can you explain variables in Swift with a brief example? I want to know how it works and why it works ahouklsjflkasjdlfkjalsdjlfjsfdlkjdslakjflksajdf")
                    
                    let parsedContent = parseBotResponse(rawText: botResponse)
                                    
                    BotMessageView(contents: parsedContent)
                    
                    UserMessageView(text: "I see brev, can you now give me excuses to not attend the exhibition?")
                }
                .padding()
            }
            
            Spacer()

            MessageInputView()
        }
        .background(Color("ChatbotBackground"))
        .edgesIgnoringSafeArea(.bottom)

    }
}

struct HeaderView: View {
    var body: some View {
        HStack(spacing: 15) {
            Image("BotOnFire")
                .resizable()
                .frame(width: 60, height: 60)
                .foregroundColor(.gray)

            VStack(alignment: .leading, spacing: 8) {
                Text("Taylor")
                    .font(.title2)
                    .fontWeight(.bold)
                Text("Ask me anything regarding Swift!")
                    .font(.headline)
                    .fontWeight(.regular)
            }
            Spacer()
        }
        .padding()
        .background(Color("ChatbotMessageColor"))
        .cornerRadius(60)
        .padding()
        .foregroundColor(.white)
    }
}

struct MessageInputView: View {
    @State private var messageText: String = ""

    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {

                TextField("Ask about Swift variables...", text: $messageText)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .foregroundColor(.white)
                    .textFieldStyle(.plain)
            
                Button(action: {
                    print("Sending: \(messageText)")
                    messageText = ""
                }) {
                    Image(systemName: "arrow.up")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 32, height: 32)
                        .background(Color.blue)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 1)
                        )
                }
                .buttonStyle(.plain)
                .disabled(messageText.isEmpty)
                .opacity(messageText.isEmpty ? 0.5 : 1.0)
                .padding()
            }
            .background(Color("MessageInputColor")) // Dark gray background
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(red: 35/255, green: 37/255, blue: 42/255), lineWidth: 1)
            )
            .padding(.horizontal)
            .padding(.vertical, 4)
            
            Text("Press Enter to send . Shift + Enter for now line")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(.bottom, 8)
    }
}

//
//// A preview provider to see the UI in Xcode.
//struct ChatbotSidebarView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatbotSidebarView(isShowing: true)
//    }
//}
