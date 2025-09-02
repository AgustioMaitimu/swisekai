//
//  OpenAIProvider.swift
//  SwiSekai
//
//  Created by Agustio Maitimu on 02/09/25.
//

import Foundation

final class OpenAIProvider: ChatProvider {
    private let apiKey: String
    private let modelName: String
    private let url = URL(string: "https://api.openai.com/v1/chat/completions")!

    init(apiKey: String, model: String) {
        self.apiKey = apiKey
        self.modelName = model
    }

    func startChat(initialSystemPrompt: String?) -> ChatSession {
        return OpenAIChatSession(apiKey: apiKey, modelName: modelName, systemPrompt: initialSystemPrompt)
    }
}

private final class OpenAIChatSession: ChatSession {
    private let apiKey: String
    private var modelName: String
    private let systemPrompt: String?
    private var messages: [ChatRequest.Message] = []
    private var triedFallback = false

    init(apiKey: String, modelName: String, systemPrompt: String?) {
        self.apiKey = apiKey
        self.modelName = modelName
        self.systemPrompt = systemPrompt
        if let sys = systemPrompt, !sys.isEmpty {
            messages.append(.init(role: "system", content: sys))
        }
    }

    struct ChatRequest: Encodable {
        struct Message: Encodable {
            let role: String
            let content: String
        }
        let model: String
        let messages: [Message]
        let temperature: Double?
    }

    struct ChatResponse: Decodable {
        struct Choice: Decodable {
            struct Message: Decodable { let content: String }
            let message: Message
        }
        let choices: [Choice]
    }

    func send(_ text: String) async throws -> String {
        messages.append(.init(role: "user", content: text))

        do {
            let req = ChatRequest(model: modelName, messages: messages, temperature: 0.7)
            var request = URLRequest(url: URL(string: "https://api.openai.com/v1/chat/completions")!)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
            request.httpBody = try JSONEncoder().encode(req)

            let (data, response) = try await URLSession.shared.data(for: request)
            if let http = response as? HTTPURLResponse, http.statusCode >= 400 {
                let body = String(data: data, encoding: .utf8) ?? ""
                // Fallback to a broadly available model once if model not found/unsupported
                if (http.statusCode == 400 || http.statusCode == 404) && !triedFallback {
                    triedFallback = true
                    modelName = "gpt-3.5-turbo"
                    return try await send(text) // retry once
                }
                throw NSError(domain: "OpenAIError", code: http.statusCode, userInfo: [NSLocalizedDescriptionKey: body])
            }
            let decoded = try JSONDecoder().decode(ChatResponse.self, from: data)
            let content = decoded.choices.first?.message.content ?? ""
            if !content.isEmpty {
                messages.append(.init(role: "assistant", content: content))
            }
            return content
        } catch {
            throw error
        }
    }
}
