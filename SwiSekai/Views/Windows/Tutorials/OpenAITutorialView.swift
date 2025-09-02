//
//  OpenAITutorialView.swift
//  SwiSekai
//
//  Created by Codex on 02/09/25.
//

import SwiftUI

struct OpenAITutorialView: View {
    @Environment(\.dismiss) private var dismiss

    private let steps: [String] = [
        "Log In or Sign Up at the OpenAI Platform.",
        "Go to API Keys: Click your profile (top-right) → API Keys.",
        "Verify Your Phone Number if prompted.",
        "Create a New Secret Key and give it a name.",
        "Copy Your Key immediately. You can’t view it again later.",
        "Add Credits under Settings → Billing if required."
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Custom back button (match detail views)
                HStack {
                    Button(action: { dismiss() }) {
                        Label("Back", systemImage: "chevron.left")
                            .font(.title3)
                            .foregroundStyle(.blue)
                            .padding(8)
                            .background(
                                RoundedRectangle(cornerRadius: 24)
                                    .fill(Color.white.opacity(0.001))
                            )
                            .overlay {
                                RoundedRectangle(cornerRadius: 24)
                                    .stroke(Color.blue, lineWidth: 1)
                            }
                    }
                    .buttonStyle(.plain)
                    .contentShape(RoundedRectangle(cornerRadius: 24))
					.padding(.top, 30)

                    Spacer()
                }

                Text("How to Get Your OpenAI API Key")
                    .font(.title2)
                    .fontWeight(.semibold)

                VStack(alignment: .leading, spacing: 12) {
                    ForEach(Array(steps.enumerated()), id: \.offset) { index, step in
                        HStack(alignment: .top, spacing: 8) {
                            Text("\(index + 1).")
                                .fontWeight(.semibold)
                            Text(step)
                        }
                    }
                }

                // Helpful links
                VStack(alignment: .leading, spacing: 8) {
                    Text("Quick Links")
                        .font(.headline)

                    Link("OpenAI Platform", destination: URL(string: "https://platform.openai.com/")!)
                    Link("API Keys page", destination: URL(string: "https://platform.openai.com/account/api-keys")!)
                    Link("Billing settings", destination: URL(string: "https://platform.openai.com/account/billing")!)
                }

                Divider()

                Text("Now that you have your API key, you can paste it into SwiSekai to get started!")
                    .foregroundColor(.secondary)
            }
            .padding()
			.padding(.leading, 15)
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle("OpenAI API Key")
    }
}

struct OpenAITutorialView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack { OpenAITutorialView() }
            .frame(width: 600, height: 500)
    }
}
