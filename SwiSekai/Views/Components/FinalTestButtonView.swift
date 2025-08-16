import SwiftUI

// this is just a placeholder, change later when the data is ready
enum FinalTestStatus {
    case available
    case unavailable
    case completed
}


struct FinalTestButton: View {
    @State private var status: FinalTestStatus = .available //placeholder, change later when data is available
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            print("Final Test tapped")
            // Later you'll update `status` from fetched data
        }) {
            Image(imageName(for: status))
                .resizable()
                .scaledToFit()
                .frame(width: 160, height: 160) // Adjust as needed
                .scaleEffect(isPressed ? 0.9 : 1.0) // Shrink on press
                .animation(.spring(response: 0.2, dampingFraction: 0.6), value: isPressed)
        }
        .buttonStyle(PlainButtonStyle()) // Remove default blue tint
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    withAnimation { isPressed = true }
                }
                .onEnded { _ in
                    withAnimation { isPressed = false }
                }
        )
    }
    
    private func imageName(for status: FinalTestStatus) -> String {
        switch status {
        case .available: return "FinalTestAvailable"
        case .unavailable: return "FinalTestUnavailable"
        case .completed: return "FinalTestCompleted"
        }
    }
}
