import SwiftUI

enum QuizStatus {
    case available
    case unavailable
    case completed
}

struct QuizIconView: View {
    var status: QuizStatus // placeholder until database logic comes in
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 90, height: 90)
                    .background(backgroundColor(for: status))
                    .cornerRadius(10)
                    .rotationEffect(.degrees(45))
                
                Image(imageName(for: status))
            }
            .frame(width: 90, height: 140)

            Text("Quiz")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
        }
    }
    private func backgroundColor(for status: QuizStatus) -> Color {
        switch status {
        case .available:
            return Color(red: 255 / 255.0, green: 123 / 255.0, blue: 29 / 255.0) // Orange
        case .unavailable:
            return Color(red: 165 / 255.0, green: 165 / 255.0, blue: 165 / 255.0) // Gray
        case .completed:
            return Color(red: 0 / 255.0, green: 168 / 255.0, blue: 237 / 255.0) // Blue
        }
    }
    
    private func imageName(for status: QuizStatus) -> String {
        switch status {
        case .available: return "QuizIconOrange"
        case .unavailable: return "QuizIconGray"
        case .completed: return "QuizIconBlue"
        }
    }
}
