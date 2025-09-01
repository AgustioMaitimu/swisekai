//
//  GeminiProvider.swift
//  SwiSekai
//
//  Created by Agustio Maitimu on 02/09/25.
//

import Foundation
import GoogleGenerativeAI

final class GeminiProvider: ChatProvider {
    private let apiKey: String
    private let modelName: String

    init(apiKey: String, model: String) {
        self.apiKey = apiKey
        self.modelName = model
    }

    func startChat(initialSystemPrompt: String?) -> ChatSession {
        let model = GenerativeModel(name: modelName, apiKey: apiKey)

        var history: [ModelContent] = []
        if let prompt = initialSystemPrompt, !prompt.isEmpty {
            history = [
                ModelContent(role: "user", parts: [ModelContent.Part.text(prompt)]),
                ModelContent(role: "model", parts: [ModelContent.Part.text("How can I help you today?")])
            ]
        }

        let chat = model.startChat(history: history)
        return GeminiChatSession(chat: chat)
    }
}

private final class GeminiChatSession: ChatSession {
    private let chat: Chat

    init(chat: Chat) {
        self.chat = chat
    }

    func send(_ text: String) async throws -> String {
        let result = try await chat.sendMessage(text)
        return result.text ?? ""
    }
}

