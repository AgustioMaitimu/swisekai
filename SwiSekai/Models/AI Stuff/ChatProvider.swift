//
//  ChatProvider.swift
//  SwiSekai
//
//  Created by Agustio Maitimu on 02/09/25.
//

import Foundation

protocol ChatSession {
    func send(_ text: String) async throws -> String
}

protocol ChatProvider {
    func startChat(initialSystemPrompt: String?) -> ChatSession
}

enum ChatProviderFactory {
    static func make(provider: AIProvider, apiKey: String, model: String? = nil) -> ChatProvider {
        switch provider {
        case .gemini:
            return GeminiProvider(apiKey: apiKey, model: model ?? provider.defaultModel)
        case .openAI:
            return OpenAIProvider(apiKey: apiKey, model: model ?? provider.defaultModel)
        }
    }
}

