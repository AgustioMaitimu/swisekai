//
//  AIProvider.swift
//  SwiSekai
//
//  Created by Agustio Maitimu on 02/09/25.
//

import Foundation

enum AIProvider: String, Codable, CaseIterable, Identifiable {
    case openAI
    case gemini

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .openAI: return "ChatGPT (OpenAI)"
        case .gemini: return "Gemini (Google)"
        }
    }

    var keychainAccount: String {
        switch self {
        case .openAI: return "openai"
        case .gemini: return "gemini"
        }
    }

    var defaultModel: String {
        switch self {
        case .openAI: return "gpt-4o-mini"
        case .gemini: return "gemini-2.5-flash"
        }
    }
}

