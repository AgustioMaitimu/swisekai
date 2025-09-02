//
//  ChatSetupView.swift
//  SwiSekai
//
//  Created by Agustio Maitimu on 02/09/25.
//

import SwiftUI

struct ChatSetupView: View {
    @ObservedObject var settings: AISettings

    @State private var selected: AIProvider = .gemini
    @State private var apiKey: String = ""
    @State private var isValidating = false
    @State private var validationMessage: String?
    @State private var showError = false
    @State private var lastValidated: (provider: AIProvider, key: String, ok: Bool)? = nil

    var onComplete: (() -> Void)?

    var body: some View {
        ScrollView {
        VStack(spacing: 16) {
            Text("Choose AI Provider")
                .font(.title2)
                .fontWeight(.bold)
			
			VStack {
				Link("How To Get Gemini API Key", destination: URL(string: "https://www.youtube.com/watch?v=6BRyynZkvf0")!)
				
				Link("How To Get OpenAI API Key", destination: URL(string: "https://www.youtube.com/watch?v=OB99E7Y1cMA")!)
			}

            Picker(selection: $selected, label: EmptyView()) {
                ForEach(AIProvider.allCases) { p in
                    Text(p.displayName).tag(p)
                }
            }
            .pickerStyle(.segmented)
            .frame(width: 300)

            VStack(alignment: .leading, spacing: 8) {
                Text("API Key for \(selected.displayName)")
                SecureField("Paste your API key", text: $apiKey)
                    .textFieldStyle(.roundedBorder)
                    .frame(maxWidth: .infinity)
            }
			.frame(width: 400, alignment: .leading)
			.onChange(of: selected) { oldValue, newValue in
				apiKey = ""
			}

            if let msg = validationMessage {
                Text(msg)
                    .font(.footnote)
                    .foregroundColor(showError ? .red : .green)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            HStack(spacing: 12) {
                Button(action: validate) {
                    if isValidating { ProgressView() } else { Text("Validate").lineLimit(1).minimumScaleFactor(0.8) }
                }
                .disabled(apiKey.isEmpty || isValidating)

                Button("Save & Continue", action: save)
                    .disabled(!(lastValidated?.provider == selected && lastValidated?.key == apiKey && lastValidated?.ok == true))
                    .buttonStyle(.borderedProminent)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity)

            Text("Your key is stored securely in your local macOS Keychain.\nWe don't have access to your key.\nOnce you log out on the chatbot, your key will be deleted.")
                .font(.footnote)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        }
        .onAppear {
            if let existing = settings.selectedProvider { selected = existing }
        }
    }

    private func validate() {
        validationMessage = nil
        showError = false
        isValidating = true

        let key = apiKey.trimmingCharacters(in: .whitespacesAndNewlines)
        let provider = selected

        Task { @MainActor in
            let result = await APIKeyValidator.validate(provider: provider, key: key)
            isValidating = false
            switch result {
            case .success:
                validationMessage = "Key is valid for \(provider.displayName)."
                showError = false
                lastValidated = (provider, key, true)
            case .failure(let err):
                switch err {
                case .invalidCredentials:
                    validationMessage = "The key is invalid."
                case .network:
                    validationMessage = "Could not validate the key. Check your connection and try again."
                case .unknown:
                    validationMessage = "Could not validate the key. Please try again."
                }
                showError = true
                lastValidated = (provider, key, false)
            }
        }
    }

    private func save() {
        do {
            try settings.saveKey(apiKey, for: selected)
            onComplete?()
        } catch {
            validationMessage = "Failed to save key: \(error.localizedDescription)"
            showError = true
        }
    }
}
