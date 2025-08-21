//
//  MultipleChoiceView.swift
//  SwiSekai
//
//  Created by Agustio Maitimu on 12/08/25.
//

import SwiftUI

struct MultipleChoiceView: View {
	@Environment(\.dismiss) var dismiss
	
	// The view now accepts a Module
	let module: Module
	let userData: UserData
	
	// State to track the current question index
	@State private var currentQuestionIndex = 0
	
	// State for the current question's interaction
	@State private var selectedAnswer: String?
	@State private var isCorrect: Bool?
	
	// State for quiz completion and score
	@State private var score = 0
	@State private var isQuizFinished = false
	
	// Computed property to get the current question easily
	private var currentQuestion: MultipleChoice {
		return module.multipleChoice[currentQuestionIndex]
	}
	
	private var progress: Double {
		// Add 1 to index because it's 0-based
		return Double(currentQuestionIndex + 1) / Double(module.multipleChoice.count)
	}
	private var progressText: String {
		return "\(currentQuestionIndex + 1)/\(module.multipleChoice.count)"
	}
	
	var body: some View {
		GeometryReader { geometry in
			ZStack {
				// Dark background for the entire view
				Color.mainBackground.ignoresSafeArea()
				
				// The main content is now wrapped in a ScrollView.
				ScrollView {
					VStack(spacing: 30) {
						//MARK:  Progress Bar
						ProgressView(value: progress) {
							Text(progressText)
								.foregroundColor(.white.opacity(0.8))
						}
						.tint(.white)
						.padding(.horizontal, 30)
						
						// MARK: Main content container
						VStack(alignment: .leading, spacing: 15) {
							// Question Text from the current question
							Text(currentQuestion.question)
								.font(geometry.size.width < 500 ? .title2 : .title)
								.fontWeight(.semibold)
								.foregroundColor(.white)
							
							// Answer Options Grid
							LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
								ForEach(currentQuestion.options, id: \.self) { option in
									AnswerButton(
										option: option,
										letter: letter(for: option),
										isSelected: selectedAnswer == option,
										isCorrect: isCorrect,
										correctAnswer: currentQuestion.answer,
										width: geometry.size.width
									) {
										selectedAnswer = option
									}
								}
							}
						}
						.padding()
						.background(
							RoundedRectangle(cornerRadius: 20)
								.fill(Color.white.opacity(0.1))
								.overlay(
									RoundedRectangle(cornerRadius: 20)
										.stroke(Color.white.opacity(0.2), lineWidth: 1)
								)
						)
						.padding(.horizontal, geometry.size.width < 500 ? 15 : 30)
						
						ResultFeedbackView(isCorrect: $isCorrect)
						
						QuizActionButton(
							isCorrect: $isCorrect,
							selectedAnswer: $selectedAnswer,
							checkAction: checkAnswer,
							nextAction: goToNextQuestion
						)
						
						Spacer()
					}
					.padding(.top, 20)
					.frame(maxWidth: 800)
					.frame(minHeight: geometry.size.height)
				}
			}
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			.sheet(isPresented: $isQuizFinished, onDismiss: {
				if module.moduleNumber == userData.currentLevel {
					userData.currentLevel += 1
				}
				
				dismiss()
				dismiss()
			}) {
				ScoreView(score: score, totalQuestions: module.multipleChoice.count)
			}
		}
	}
	
	// Helper to get the letter for each option (A, B, C, D)
	private func letter(for option: String) -> String {
		guard let index = currentQuestion.options.firstIndex(of: option) else { return "" }
		let letters = ["A", "B", "C", "D"]
		return letters[index]
	}
	
	// Function to check the answer and update the score
	private func checkAnswer() {
		if let selected = selectedAnswer {
			let wasCorrect = (selected == currentQuestion.answer)
			if wasCorrect {
				score += 1
			}
			withAnimation {
				isCorrect = wasCorrect
			}
		}
	}
	
	// Function to advance to the next question or finish the quiz
	private func goToNextQuestion() {
		if currentQuestionIndex < module.multipleChoice.count - 1 {
			currentQuestionIndex += 1
			// Reset state for the new question
			selectedAnswer = nil
			isCorrect = nil
		} else {
			// End of the quiz, present the score screen
			isQuizFinished = true
		}
	}
}

// MARK: - Subviews

struct AnswerButton: View {
	let option: String
	let letter: String
	let isSelected: Bool
	let isCorrect: Bool?
	let correctAnswer: String
	let width: CGFloat // Receive width for dynamic sizing.
	let action: () -> Void
	
	// Computed property to determine the border color dynamically
	private var borderColor: Color {
		guard let isCorrect = isCorrect else {
			// Before the answer is checked, highlight the selected option in blue
			return isSelected ? .blue : .clear
		}
		
		// After the answer is checked
		if isSelected {
			// If this is the button the user selected, show green for correct, red for incorrect
			return isCorrect ? Color("QuizCorrectColor") : Color("QuizIncorrectColor")
		} else if option == correctAnswer {
			// If this is the correct answer (and the user picked something else), highlight it in green
			return Color("QuizCorrectColor")
		} else {
			// Otherwise, no border
			return .clear
		}
	}
	
	// Check if the buttons should be disabled
	private var isDisabled: Bool {
		isCorrect != nil
	}
	
	var body: some View {
		Button(action: action) {
			ZStack(alignment: .topLeading) {
				// Center the main option text using Spacers
				HStack {
					Spacer()
					VStack {
						Spacer()
						// This will automatically select the largest font that fits
						ViewThatFits {
							Text(option).font(.largeTitle)
							Text(option).font(.title)
							Text(option).font(.title2)
							Text(option).font(.body)
						}
						.fontWeight(.semibold)
						.multilineTextAlignment(.center)
						.padding(.horizontal, 5) // Padding to avoid overlapping with the letter
						Spacer()
					}
					Spacer()
				}
				
				// Position the letter in the top-left corner
				Text(letter)
					.font(width < 500 ? .title2.bold() : .title.bold())
					.padding(width < 500 ? 12 : 15)
			}
			// Use adaptive height instead of a fixed minimum size.
			.frame(maxWidth: .infinity)
			.frame(minHeight: width < 500 ? 100 : 120)
			.background(
				RoundedRectangle(cornerRadius: 12)
					.fill(Color.black.opacity(0.3))
			)
			.foregroundColor(.white)
			.overlay(
				RoundedRectangle(cornerRadius: 12)
					.stroke(borderColor, lineWidth: 4) // Use the dynamic border color
			)
		}
		.buttonStyle(.plain)
		.disabled(isDisabled) // Disable the button when needed
		.opacity(isDisabled && !isSelected && option != correctAnswer ? 0.6 : 1.0) // Fade out irrelevant options
		.animation(.easeInOut, value: borderColor)
	}
}

struct ResultFeedbackView: View {
	@Binding var isCorrect: Bool?
	
	var body: some View {
		// Only show the view if an answer has been checked
		if let isCorrect = isCorrect {
			HStack {
				Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
				Text(isCorrect ? "Correct!" : "Incorrect")
					.fontWeight(.bold)
			}
			.font(.title2)
			.foregroundColor(isCorrect ? Color("QuizCorrectColor") : Color("QuizIncorrectColor"))
			.transition(.scale.combined(with: .opacity))
		}
	}
}

struct QuizActionButton: View {
	@Binding var isCorrect: Bool?
	@Binding var selectedAnswer: String?
	let checkAction: () -> Void
	let nextAction: () -> Void
	
	// Check if the answer has been verified
	private var isAnswerChecked: Bool {
		isCorrect != nil
	}
	
	// Determine the button's color based on the state
	private var buttonColor: Color {
		if !isAnswerChecked {
			// If we are in "Check" mode
			return selectedAnswer == nil ? .gray : Color.blue // Disabled vs. Enabled
		} else {
			// If we are in "Next" mode
			return isCorrect == true ? Color("QuizCorrectColor") : Color("QuizIncorrectColor")
		}
	}
	
	private var buttonText: String {
		isAnswerChecked ? "Next" : "Check"
	}
	
	var body: some View {
		Button(action: {
			if isAnswerChecked {
				nextAction()
			} else {
				checkAction() // Call the passed-in checkAction
			}
		}) {
			Text(buttonText)
				.font(.title2)
				.fontWeight(.bold)
				.frame(maxWidth: .infinity)
				.padding()
				.background(buttonColor)
				.foregroundColor(.white)
				.cornerRadius(15)
		}
		.buttonStyle(.plain)
		.padding(.horizontal)
		.disabled(selectedAnswer == nil && !isAnswerChecked)
		.animation(.easeInOut, value: buttonColor)
	}
}

// MARK: - Score View

struct ScoreView: View {
	let score: Int
	let totalQuestions: Int
	@Environment(\.dismiss) var dismiss
	
	var body: some View {
		ZStack {
			VStack(spacing: 25) {
				Text("Quiz Complete!")
					.font(.largeTitle)
					.fontWeight(.bold)
					.foregroundColor(.white)
				
				VStack{
					Text("Your Score")
						.font(.title2)
						.foregroundColor(.gray)
					
					Text("\(score)/\(totalQuestions)")
						.font(.system(size: 80, weight: .bold))
						.foregroundColor(.white)
				}
				
				Button(action: {
					dismiss()
				}) {
					Text("Done")
						.fontWeight(.bold)
						.frame(maxWidth: .infinity)
						.padding()
						.background(Color("ButtonColor"))
						.foregroundColor(.white)
						.cornerRadius(15)
				}
				.buttonStyle(.plain)
				.padding(.horizontal)
			}
		}
		.padding()
		.padding(.vertical)
		.background(.mainBackground)
	}
}
