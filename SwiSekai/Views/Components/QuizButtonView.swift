import SwiftUI

enum QuizStatus {
    case available
    case unavailable
}

struct QuizIconView: View {
    var status: QuizStatus // placeholder until database logic comes in
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 90, height: 90)
                    .background(status == .available
                                ? Color(red: 0, green: 0.66, blue: 0.93) // Blue
                                : Color(red: 0.65, green: 0.65, blue: 0.65)) // Gray
                    .cornerRadius(10)
                    .rotationEffect(.degrees(45))
                
                Image(status == .available ? "QuizIconBlue" : "QuizIconGray")
            }
            .frame(width: 90, height: 140)

            Text("Quiz")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
        }
    }
}
