//
//  MultipleChoiceView.swift
//  SwiSekai
//
//  Created by Agustio Maitimu on 12/08/25.
//

import SwiftUI

struct MultipleChoiceView: View {
	let question: String
	let options: [String]
	let correctAnswer: String
	
	@State private var selectedOption: String? = nil
	@State private var isAnswered: Bool = false
	
	var body: some View {
		VStack(alignment: .leading, spacing: 12) {
			Text(question)
				.font(.headline)
				.bold()
			
			ForEach(options, id: \.self) { option in
				Button(action: {
					if !isAnswered {
						selectedOption = option
						isAnswered = true
					}
				}) {
					HStack {
						Text(option)
						Spacer()
						if isAnswered && option == selectedOption {
							if option == correctAnswer {
								Image(systemName: "checkmark.circle.fill")
									.foregroundColor(.green)
							} else {
								Image(systemName: "xmark.circle.fill")
									.foregroundColor(.red)
							}
						}
					}
					.padding()
					.frame(maxWidth: .infinity)
					.background(buttonBackgroundColor(for: option))
					.foregroundColor(.primary)
					.cornerRadius(8)
				}
				.disabled(isAnswered)
				.opacity(isAnswered && selectedOption != option ? 0.5 : 1.0)
			}
		}
		.padding(.vertical, 8)
	}
	
	private func buttonBackgroundColor(for option: String) -> Color {
		guard isAnswered else {
			return Color.gray.opacity(0.2)
		}
		
		if option == correctAnswer {
			return .green.opacity(0.3)
		}
		
		if option == selectedOption {
			return .red.opacity(0.3)
		}
		
		return Color.gray.opacity(0.2)
	}
}

//#Preview {
//    MultipleChoiceView()
//}
