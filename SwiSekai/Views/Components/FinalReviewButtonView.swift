import SwiftUI

// this is just a placeholder, change later when the data is ready
enum FinalReviewStatus {
    case available
    case unavailable
    case completed
}


struct FinalReviewButton: View {
    let status: FinalReviewStatus 
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
                .padding(.bottom, 50)
               
            
            Rectangle()
              .foregroundColor(.clear)
              .frame(width: 453, height: 2)
              .background(.white.opacity(0.2))
              
        }
    }
    
    private func imageName(for status: FinalReviewStatus) -> String {
        switch status {
        case .available: return "FinalReviewAvailable"
        case .unavailable: return "FinalReviewUnavailable"
        case .completed: return "FinalReviewCompleted"
        }
    }
}
