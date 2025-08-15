//
//  MultipleChoiceView.swift
//  SwiSekai
//
//  Created by Agustio Maitimu on 12/08/25.
//

import SwiftUI

struct MultipleChoiceView: View {
    // The view now accepts a Module
    let module: Module
    
    // State to track the current question index
    @State private var currentQuestionIndex = 0
    
    // State for the current question's interaction
    @State private var selectedAnswer: String?
    @State private var isCorrect: Bool?
    
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
        ZStack {
            // Dark background for the entire view
            Color("BackgroundColor").ignoresSafeArea()
            
            VStack(spacing: 30) {
                //MARK:  Progress Bar
                ProgressView(value: progress) {
                    Text(progressText)
                        .foregroundColor(.white.opacity(0.8))
                }
                .tint(.white)
                .padding(.horizontal, 40)
                
                // MARK: Main content container
                VStack(alignment: .leading, spacing: 25) {
                    // Question Text from the current question
                    Text(currentQuestion.question)
                        .font(.title)
                        .foregroundColor(.white)
                    
                    // Answer Options Grid
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        ForEach(currentQuestion.options, id: \.self) { option in
                            AnswerButton(
                                option: option,
                                letter: letter(for: option),
                                isSelected: selectedAnswer == option,
                                // Disable the button after the answer is checked
                                isDisabled: isCorrect != nil
                            ) {
                                // Action to perform on tap
                                selectedAnswer = option
                            }
                        }
                    }
                }
                .padding()
                .background(
                    // Frosted glass effect
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white.opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )
                )
                .padding(.horizontal)
                
                QuizActionButton(
                    isCorrect: $isCorrect,
                    selectedAnswer: $selectedAnswer,
                    correctAnswer: currentQuestion.answer,
                    nextAction: goToNextQuestion
                )
                
                Spacer()
            }
            .padding(.top, 20)
            .frame(width: 500)
        }
    }
    
    // Helper to get the letter for each option (A, B, C, D)
    private func letter(for option: String) -> String {
        guard let index = currentQuestion.options.firstIndex(of: option) else { return "" }
        let letters = ["A", "B", "C", "D"]
        return letters[index]
    }
    
    // Function to advance to the next question
    private func goToNextQuestion() {
        if currentQuestionIndex < module.multipleChoice.count - 1 {
            currentQuestionIndex += 1
            // Reset state for the new question
            selectedAnswer = nil
            isCorrect = nil
        } else {
            // This is where you would handle the end of the quiz
            print("Quiz finished!")
            // For example, you could dismiss the view or navigate to a results screen.
        }
    }
}

// MARK: - Subviews

struct AnswerButton: View {
    let option: String
    let letter: String
    let isSelected: Bool
    let isDisabled: Bool
    let action: () -> Void
    
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
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 5) // Padding to avoid overlapping with the letter
                        Spacer()
                    }
                    Spacer()
                }

                // Position the letter in the top-left corner
                Text(letter)
                    .font(.title)
                    .padding(15)
            }
            .frame(minWidth: 180, minHeight: 120)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.black.opacity(0.3))
            )
            .foregroundColor(.white)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 4)
            )
        }
        .buttonStyle(.plain)
        .disabled(isDisabled) // Disable the button when needed
        .opacity(isDisabled && !isSelected ? 0.6 : 1.0) // Fade out unselected options
        .padding(.horizontal, 5)
    }
}

struct QuizActionButton: View {
    @Binding var isCorrect: Bool?
    @Binding var selectedAnswer: String?
    let correctAnswer: String
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
            return isCorrect == true ? .green : .red
        }
    }
    
    private var buttonText: String {
        isAnswerChecked ? "Next" : "Check"
    }
    
    var body: some View {
        Button(action: {
            if isAnswerChecked {
                // If the button says "Next", perform the next action
                nextAction()
            } else {
                // If the button says "Check", verify the answer
                if let selected = selectedAnswer {
                    withAnimation {
                        isCorrect = (selected == correctAnswer)
                    }
                }
            }
        }) {
            Text(buttonText)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity)
                .padding()
                .background(buttonColor)
                .foregroundColor(.white)
                .cornerRadius(15)
        }
        .buttonStyle(.plain)
        .padding(.horizontal)
        // Disable the "Check" button if no answer is selected
        .disabled(selectedAnswer == nil && !isAnswerChecked)
        .animation(.easeInOut, value: buttonColor)
    }
}

//#Preview {
//    MultipleChoiceView()
//}
