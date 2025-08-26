//
//  ChatbotView.swift
//  SwiSekai
//
//  Created by Ryan Hangralim on 24/08/25.
//

import SwiftUI
import GoogleGenerativeAI

enum ChatRole {
    case user
    case bot
}

struct ChatMessage: Identifiable, Equatable {
    let id = UUID()
    let role: ChatRole
    let text: String
}

struct ChatbotSidebarView: View {
    @State private var chat: Chat
    @State private var chatHistory: [ChatMessage] = [
        ChatMessage(role: .bot, text: "How can I help you today?")
    ]
    @State var userPrompt = ""
    @State var isLoading = false
    @Binding var isShowing: Bool
    
    init(isShowing: Binding<Bool>) {
        self._isShowing = isShowing
        
        let model = GenerativeModel(name: "gemini-2.5-flash", apiKey: APIKey.default)
        
        let systemPrompt = """
            You are a helpful programming assistant called Taylor. Your sole purpose is to answer questions about the Swift programming language and its related frameworks like SwiftUI and UIKit. If you are asked about any other topic, politely decline and state that you can only discuss Swift.
            """

        let initialHistory = [
            ModelContent(role: "user", parts: [ModelContent.Part.text(systemPrompt)]),
            ModelContent(role: "model", parts: [ModelContent.Part.text("How can I help you today?")])
        ]

        // Start the chat with the predefined history
        self._chat = State(initialValue: model.startChat(history: initialHistory))
    }
    
    
    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Header
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
            .padding([.top, .leading])
            
            HeaderView()
            
            // MARK: - Chat History View
            ScrollViewReader { scrollViewProxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(chatHistory) { message in
                            // Display the correct view based on the message's role
                            switch message.role {
                            case .user:
                                HStack {
                                    Spacer() // This pushes the bubble to the right
                                    UserMessageView(text: message.text)
                                }
                            case .bot:
                                HStack {
                                    let parsedContent = parseBotResponse(rawText: message.text)
                                    BotMessageView(contents: parsedContent)
                                    Spacer() // This pushes the bubble to the left
                                }
                            }
                        }
                        
                        // Show a loading indicator when the bot is "typing"
                        if isLoading {
                            HStack {
                                Spacer()
                                ProgressView()
                                    .padding()
                                Spacer()
                            }
                        }
                    }
                    .padding()
                }
                .onChange(of: chatHistory) {
                    if let lastMessage = chatHistory.last {
                        withAnimation {
                            scrollViewProxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
            }
            
            Spacer()
            
            // MARK: - Message Input
            MessageInputView(userPrompt: $userPrompt) {
                sendMessage()
            }
        }
        .background(Color("ChatbotBackground"))
        .edgesIgnoringSafeArea(.bottom)
    }
    
    func sendMessage() {
        guard !userPrompt.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let newUserMessage = ChatMessage(role: .user, text: userPrompt)
        chatHistory.append(newUserMessage)
        
        let promptToSend = userPrompt
        userPrompt = ""
        
        generateResponse(for: promptToSend)
    }
    
    func generateResponse(for prompt: String) {
        isLoading = true
        
        Task {
            do {
                let result = try await chat.sendMessage(prompt)
                isLoading = false
                
                if let botResponseText = result.text {
                    let botMessage = ChatMessage(role: .bot, text: botResponseText)
                    chatHistory.append(botMessage)
                } else {
                    let errorMessage = ChatMessage(role: .bot, text: "Sorry, I couldn't get a response.")
                    chatHistory.append(errorMessage)
                }
                
            } catch {
                isLoading = false
                let errorMessage = ChatMessage(role: .bot, text: "Something went wrong! \n\(error.localizedDescription)")
                chatHistory.append(errorMessage)
                print("Error generating response: \(error)")
            }
        }
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
    @Binding var userPrompt: String
    
    var onSendMessage: () -> Void
    
    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                TextField("Ask about Swift variables...", text: $userPrompt, axis: .vertical)
                    .lineLimit(5) // Allow for multi-line input
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .foregroundColor(.white)
                    .textFieldStyle(.plain)
                    .onSubmit(onSendMessage)
                
                Button(action: onSendMessage) {
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
                .disabled(userPrompt.isEmpty)
                .opacity(userPrompt.isEmpty ? 0.5 : 1.0)
                .padding(.trailing)
            }
            .background(Color("MessageInputColor"))
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color(red: 35/255, green: 37/255, blue: 42/255), lineWidth: 1)
            )
            .padding(.horizontal)
            .padding(.vertical, 4)
            
            Text("Press Enter to send. Shift + Enter for a new line.")
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
