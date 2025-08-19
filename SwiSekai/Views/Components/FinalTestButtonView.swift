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
        
        VStack {
            
            // The Image is now the tappable area, not a separate Button.
            Image(imageName(for: status))
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .scaleEffect(isPressed ? 0.9 : 1.0)
                .animation(.spring(response: 0.2, dampingFraction: 0.6), value: isPressed)
            
            Text("Final Review")
                .font(
                    Font.custom("SF Pro", size: 22)
                        .weight(.bold)
                )
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .frame(width: 139, alignment: .top)
        }
    }
    
    private func imageName(for status: FinalTestStatus) -> String {
        switch status {
        case .available: return "FinalTestAvailable"
        case .unavailable: return "FinalTestUnavailable"
        case .completed: return "FinalTestCompleted"
        }
    }
}
