import SwiftUI

enum ChapterStatus {
    case available
    case unavailable
    case completed
}

struct ChapterButton: View {
    let chapterName: String
    let status: ChapterStatus
    @State private var isPressed = false

    var body: some View {
        Button(action: {
            print("Pressed")
        }) {
            ZStack(alignment: .topLeading) {
                // Bottom 3D height layer (only visible below the button)
                RoundedRectangle(cornerRadius: 20)
                    .fill(shadowColor)
                    .frame(width: 420, height: 83)
                    .offset(y: bottomOffset)

                // Foreground button face
                HStack {
                    Image(systemName: "book.pages")
                        .font(.system(size: 45))
                        .foregroundColor(contentColor)

                    VStack(alignment: .leading) {
                        Text(chapterName)
                            .font(Font.custom("SF Pro", size: 24).weight(.bold))
                            .foregroundColor(contentColor)
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                    }
                }
                .padding(.horizontal, 16)
                .frame(width: 420, height: 83)
                .background {
                    switch status {
                    case .available:
                        // Original orange gradient for current chapter
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(red: 0.99, green: 0.25, blue: 0),
                                Color(red: 1, green: 0.49, blue: 0.25)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    case .completed:
                        // Blue fill for completed chapters: #5BC7F5
                        Color(red: 91/255, green: 199/255, blue: 245/255)
                    case .unavailable:
                        Color(red: 0.85, green: 0.85, blue: 0.85)
                    }
                }
                .cornerRadius(20)
                .overlay(
                    Group {
                        if status == .completed {
                            // Gradient border: from #5BC7F5 to white (left -> right)
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color(red: 91/255, green: 199/255, blue: 245/255),
                                            .white
                                        ]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    ),
                                    lineWidth: 2
                                )
                        }
                    }
                )
                .offset(y: topOffset)
            }
            .animation(.easeOut(duration: 0.1), value: isPressed)
        }
        .buttonStyle(.plain)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in withAnimation(.easeOut(duration: 0.1)) { if status != .unavailable { isPressed = true } } }
                .onEnded { _ in withAnimation(.easeOut(duration: 0.1)) { isPressed = false } }
        )
    }
}

// MARK: - Styling helpers
private extension ChapterButton {
    var contentColor: Color {
        switch status {
        case .available, .completed:
            return .white
        case .unavailable:
            return Color(red: 90/255, green: 90/255, blue: 90/255)
        }
    }

    var shadowColor: Color {
        switch status {
        case .available:
            // Original orange shadow
            return Color(red: 164/255, green: 61/255, blue: 31/255)
        case .completed:
            // #377F9C
            return Color(red: 55/255, green: 127/255, blue: 156/255)
        case .unavailable:
            // #6B6B6B
            return Color(red: 107/255, green: 107/255, blue: 107/255)
        }
    }

    var shadowYOffset: CGFloat {
        switch status {
        case .unavailable:
            return 6
        case .available, .completed:
            return isPressed ? 2 : 6
        }
    }
    
    var topOffset: CGFloat { isPressed ? 4 : 0 }
    var bottomOffset: CGFloat { topOffset + shadowYOffset }
}
