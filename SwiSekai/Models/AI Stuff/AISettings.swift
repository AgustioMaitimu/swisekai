//
//  AISettings.swift
//  SwiSekai
//
//  Created by Agustio Maitimu on 02/09/25.
//

import Foundation

final class AISettings: ObservableObject {
    static let shared = AISettings()

    @Published var selectedProvider: AIProvider? {
        didSet {
            let value = selectedProvider?.rawValue
            UserDefaults.standard.set(value, forKey: Self.providerKey)
        }
    }

    @Published var hasStoredKey: Bool = false

    private static let providerKey = "AISettings.selectedProvider"

    private init() {
        if let raw = UserDefaults.standard.string(forKey: Self.providerKey) {
            selectedProvider = AIProvider(rawValue: raw)
        } else {
            selectedProvider = nil
        }
        refreshKeyPresence()
    }

    func refreshKeyPresence() {
        if let provider = selectedProvider, (try? KeychainStore.read(account: provider.keychainAccount)) ?? nil != nil {
            hasStoredKey = true
        } else {
            hasStoredKey = false
        }
    }

    func saveKey(_ key: String, for provider: AIProvider) throws {
        try KeychainStore.save(key: key, account: provider.keychainAccount)
        selectedProvider = provider
        refreshKeyPresence()
    }

    func loadKey() -> String? {
        guard let provider = selectedProvider else { return nil }
        return try? KeychainStore.read(account: provider.keychainAccount)
    }

    func deleteKey() {
        if let provider = selectedProvider {
            _ = try? KeychainStore.delete(account: provider.keychainAccount)
        }
        hasStoredKey = false
        selectedProvider = nil
    }
}

