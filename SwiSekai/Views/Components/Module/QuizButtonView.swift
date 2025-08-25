import SwiftUI

enum QuizStatus {
    case available
    case unavailable
    case completed
}

// The QuizIconView no longer manages its own gestures.
// It relies on an `isPressed` property passed to it.
struct QuizIconView: View {
    var status: QuizStatus
    var isPressed: Bool // Add this property to control the pressed state

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                // The shadow image is the bottom layer.
                Image(shadowName(for: status))
                    .resizable()
                    .scaledToFit()
                    .offset(y: 3)
                    .frame(width: 110, height: 110)

                // The main button image moves down when isPressed is true.
                Image(buttonName(for: status))
                    .resizable()
                    .scaledToFit()
                    .offset(y: isPressed ? 6 : 0) // Use the isPressed property here
            }
            .frame(width: 140, height: 140)
            // Animate the change when isPressed value changes
            .animation(.easeOut(duration: 0.1), value: isPressed)

            Text("Quiz")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
        }
        .frame(width: 150)
    }

    /// Determines the correct SVG asset name for the main button.
    private func buttonName(for status: QuizStatus) -> String {
        switch status {
        case .available: return "QuizButtonAvailable"
        case .unavailable: return "QuizButtonLocked"
        case .completed: return "QuizButtonFinished"
        }
    }

    /// Determines the correct SVG asset name for the shadow layer.
    private func shadowName(for status: QuizStatus) -> String {
        switch status {
        case .available: return "QuizButtonAvailable-Shadow"
        case .completed: return "QuizButtonFinish-Shadow"
        case .unavailable: return "QuizButtonLocked"
        }
    }
}


// Create a new ButtonStyle to apply the custom appearance and animation.
struct QuizNavigationLinkStyle: ButtonStyle {
    let status: QuizStatus

    func makeBody(configuration: Configuration) -> some View {
        QuizIconView(
            status: status,
            isPressed: configuration.isPressed // Pass the pressed state to the view
        )
    }
}


// The preview remains helpful for testing the view's appearance.
struct QuizIconView_Previews: PreviewProvider {
    static var previews: some View {
        HStack(spacing: 20) {
            Button(action: {}) { EmptyView() }.buttonStyle(QuizNavigationLinkStyle(status: .available))
            Button(action: {}) { EmptyView() }.buttonStyle(QuizNavigationLinkStyle(status: .unavailable))
            Button(action: {}) { EmptyView() }.buttonStyle(QuizNavigationLinkStyle(status: .completed))
        }
        .padding()
        .background(Color.gray)
    }
}
