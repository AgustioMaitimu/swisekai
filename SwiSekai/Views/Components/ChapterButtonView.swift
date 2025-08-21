import SwiftUI

enum ChapterStatus {
    case available
    case unavailable
}

struct ChapterButton: View {
    let chapterName: String
    let status: ChapterStatus
    @State private var isPressed = false

    var body: some View {
        Button(action: {
            print("Pressed")
        }) {
            HStack {
                Image(systemName: "book.pages")
                    .font(.system(size: 45))
                    .foregroundColor(status == .available ? .white : Color(red: 90/255, green: 90/255, blue: 90/255))
                
                VStack(alignment: .leading) {
                    Text(chapterName)
                        .font(Font.custom("SF Pro", size: 24).weight(.bold))
                        .foregroundColor(status == .available ? .white : Color(red: 90/255, green: 90/255, blue: 90/255))
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                }
            }
            .padding(.horizontal, 16)
            .frame(width: 453, height: 83)
            .background {
                if status == .available {
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.99, green: 0.25, blue: 0),
                            Color(red: 1, green: 0.49, blue: 0.25)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                } else {
                    Color(red: 0.85, green: 0.85, blue: 0.85)
                }
            }
            .cornerRadius(20)
            .shadow(
                color: status == .unavailable
                    ? Color(red: 107/255, green: 107/255, blue: 107/255) // This is #6B6B6B
                    : Color(red: 164/255, green: 61/255, blue: 31/255),  // Original color
                radius: 0,
                x: 0,
                y: status == .unavailable ? 6 : (isPressed ? 2 : 6) // Disable press effect if unavailable
            )
            .offset(y: isPressed ? 4 : 0)
            .animation(.easeOut(duration: 0.1), value: isPressed)
        }
        .buttonStyle(.plain)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in withAnimation(.easeOut(duration: 0.1)) { isPressed = true } }
                .onEnded { _ in withAnimation(.easeOut(duration: 0.1)) { isPressed = false } }
        )
    }
}
