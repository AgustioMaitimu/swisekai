//
//  GeminiTutorialView.swift
//  SwiSekai
//
//  Created by Codex on 02/09/25.
//

import SwiftUI

struct GeminiTutorialView: View {
    @Environment(\.dismiss) private var dismiss

    private let steps: [String] = [
        "Go to AI Studio in your browser.",
        "Accept the Terms if prompted.",
        "Click Get API key in the top-left.",
        "Create Your API Key in the dialog.",
        "Copy and save the key somewhere secure."
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

                Text("How to Get Your Google Gemini API Key")
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

                    Link("Google AI Studio", destination: URL(string: "https://aistudio.google.com/")!)
                    Link("Gemini API Keys", destination: URL(string: "https://aistudio.google.com/app/apikey")!)
                }

                Divider()

                Text("You can now use your Google Gemini API key to start chatting with SwiSekai!")
                    .foregroundColor(.secondary)
            }
            .padding()
			.padding(.leading, 15)
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Gemini API Key")
    }
}

struct GeminiTutorialView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack { GeminiTutorialView() }
            .frame(width: 600, height: 500)
    }
}
