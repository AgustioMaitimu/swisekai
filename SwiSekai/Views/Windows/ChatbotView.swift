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
    @State private var chatSession: ChatSession?
    @State private var chatHistory: [ChatMessage] = [
        ChatMessage(role: .bot, text: "How can I help you today?")
    ]
    @State var userPrompt = ""
    @State var isLoading = false
    @Binding var isShowing: Bool
    @StateObject private var settings = AISettings.shared
	
	
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
                if settings.hasStoredKey {
                    Button("Logout") { confirmLogout() }
                        .buttonStyle(.bordered)
                }
            }
            .padding([.top, .leading, .trailing])
            
            HeaderView()
			
            // MARK: - Either Setup or Chat View
            if !(settings.selectedProvider != nil && settings.hasStoredKey) {
                ChatSetupView(settings: settings) {
                    setUpChatSession()
                }
                .padding(.horizontal)
            } else {
                ScrollViewReader { scrollViewProxy in
                    ScrollView {
                        VStack(alignment: .leading, spacing: 12) {
                            ForEach(chatHistory) { message in
                                switch message.role {
                                case .user:
                                    HStack { Spacer(); UserMessageView(text: message.text) }
                                case .bot:
                                    HStack {
                                        let parsedContent = parseBotResponse(rawText: message.text)
                                        BotMessageView(contents: parsedContent)
                                        Spacer()
                                    }
                                }
                            }
                            if isLoading {
                                HStack { Spacer(); ProgressView().padding(); Spacer() }
                            }
                        }
                        .padding()
                    }
                    .onChange(of: chatHistory) {
                        if let lastMessage = chatHistory.last {
                            withAnimation { scrollViewProxy.scrollTo(lastMessage.id, anchor: .bottom) }
                        }
                    }
                }
            }
			
			Spacer()
			
			// MARK: - Message Input
			if settings.selectedProvider != nil && settings.hasStoredKey {
				MessageInputView(userPrompt: $userPrompt) {
					sendMessage()
				}
			}
		}
        .padding(.top, 35)
        .background(Color("ChatbotBackground"))
        .edgesIgnoringSafeArea(.bottom)
        .onAppear { setUpChatSession() }
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
                guard let chatSession = chatSession else { return }
                let resultText = try await chatSession.send(prompt)
                isLoading = false
                
                if !resultText.isEmpty {
                    let botMessage = ChatMessage(role: .bot, text: resultText)
                    chatHistory.append(botMessage)
                } else {
                    let errorMessage = ChatMessage(role: .bot, text: "Sorry, I couldn't get a response.")
                    chatHistory.append(errorMessage)
                }
                
            } catch {
                isLoading = false
                let friendly: String
                if let ns = error as NSError?, ns.domain == "OpenAIError" {
                    switch ns.code {
                    case 401, 403:
                        friendly = "OpenAI key is invalid or not authorized. Try re‑entering your key or switch to Gemini via Logout."
                    case 429:
                        friendly = "OpenAI usage quota exceeded. Add billing or wait, or switch to Gemini via Logout."
                    case 400, 404:
                        friendly = "Selected OpenAI model isn’t available. I’ll try a fallback, or switch models."
                    default:
                        friendly = "OpenAI error (\(ns.code)). Please try again or switch provider."
                    }
                } else {
                    friendly = "Something went wrong! \n\(error.localizedDescription)"
                }
                let errorMessage = ChatMessage(role: .bot, text: friendly)
                chatHistory.append(errorMessage)
                print("Error generating response: \(error)")
            }
        }
    }

    private func setUpChatSession() {
        guard let provider = settings.selectedProvider, let key = settings.loadKey() else { return }
        let systemPrompt = """
        You are a helpful programming assistant called Taylor. Your sole purpose is to answer questions about the Swift programming language and its related frameworks like SwiftUI and UIKit in an easy-to-understand way, using clear explanations and simple examples that beginners can follow, keep it short and concise. If you are asked about any other topic, politely decline and state that you can only discuss Swift.
        """
        let providerInstance = ChatProviderFactory.make(provider: provider, apiKey: key, model: provider.defaultModel)
        self.chatSession = providerInstance.startChat(initialSystemPrompt: systemPrompt)
    }

    private func confirmLogout() {
        // Simple immediate logout; could add confirmation dialog if desired
        settings.deleteKey()
        chatSession = nil
        chatHistory = [ChatMessage(role: .bot, text: "How can I help you today?")]
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
					.layoutPriority(1)
				
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
				.lineLimit(1)
				.minimumScaleFactor(0.8)
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
