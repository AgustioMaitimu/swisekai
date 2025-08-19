import SwiftUI

struct ChapterButton: View {
    let chapterName: String
    @State private var isPressed = false

    var body: some View {
        Button(action: {
            print("Pressed")
        }) {
            HStack {
                Image(systemName: "book.pages")
                    .font(.system(size: 45))
                
                VStack(alignment: .leading) {
                    Text(chapterName)
                        .font(Font.custom("SF Pro", size: 24).weight(.bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                }
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 30))
            }
            .padding(.horizontal, 16)
            .frame(width: 453, height: 83)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.99, green: 0.25, blue: 0),
                        Color(red: 1, green: 0.49, blue: 0.25),
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .cornerRadius(20)
            .shadow(color: Color(red: 164/255, green: 61/255, blue: 31/255),
                    radius: 0,
                    x: 0,
                    y: isPressed ? 2 : 6)
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
