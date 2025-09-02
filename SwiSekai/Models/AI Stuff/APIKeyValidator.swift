//
//  APIKeyValidator.swift
//  SwiSekai
//
//  Created by Agustio Maitimu on 02/09/25.
//

import Foundation

enum APIKeyValidationError: LocalizedError {
    case invalidCredentials(String)
    case network(String)
    case unknown(Int, String)

    var errorDescription: String? {
        switch self {
        case .invalidCredentials(let msg): return msg
        case .network(let msg): return msg
        case .unknown(let code, let body): return "HTTP \(code): \(body)"
        }
    }
}

struct APIKeyValidator {
    static func validate(provider: AIProvider, key: String) async -> Result<Void, APIKeyValidationError> {
        do {
            switch provider {
            case .gemini:
                var comps = URLComponents(string: "https://generativelanguage.googleapis.com/v1/models")!
                comps.queryItems = [URLQueryItem(name: "key", value: key)]
                var req = URLRequest(url: comps.url!)
                req.httpMethod = "GET"
                let (data, resp) = try await URLSession.shared.data(for: req)
                guard let http = resp as? HTTPURLResponse else {
                    return .failure(.network("No response"))
                }
                if http.statusCode == 200 {
                    return .success(())
                } else if http.statusCode == 401 || http.statusCode == 403 {
                    let body = String(data: data, encoding: .utf8) ?? ""
                    return .failure(.invalidCredentials("Gemini key rejected (\(http.statusCode)). \(body)"))
                } else {
                    let body = String(data: data, encoding: .utf8) ?? ""
                    return .failure(.unknown(http.statusCode, body))
                }

            case .openAI:
                var req = URLRequest(url: URL(string: "https://api.openai.com/v1/models")!)
                req.httpMethod = "GET"
                req.setValue("Bearer \(key)", forHTTPHeaderField: "Authorization")
                let (data, resp) = try await URLSession.shared.data(for: req)
                guard let http = resp as? HTTPURLResponse else {
                    return .failure(.network("No response"))
                }
                if http.statusCode == 200 {
                    return .success(())
                } else if http.statusCode == 401 || http.statusCode == 403 {
                    let body = String(data: data, encoding: .utf8) ?? ""
                    return .failure(.invalidCredentials("OpenAI key rejected (\(http.statusCode)). \(body)"))
                } else {
                    let body = String(data: data, encoding: .utf8) ?? ""
                    return .failure(.unknown(http.statusCode, body))
                }
            }
        } catch {
            return .failure(.network(error.localizedDescription))
        }
    }
}

