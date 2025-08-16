import SwiftUI

//  Helper view for the sine path
struct SinePathView: View {
    let verticalSpacing: CGFloat
    let waveAmplitude: CGFloat
    let waveFrequency: CGFloat
    let totalHeight: CGFloat

    var body: some View {
        Path { path in
            path.move(to: CGPoint(x: waveAmplitude * sin(0), y: 0))
            let step: CGFloat = 0.5
            for y in stride(from: CGFloat(0), through: totalHeight, by: step) {
                let x = waveAmplitude * sin(y / verticalSpacing * waveFrequency)
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        .stroke(style: StrokeStyle(lineWidth: 0, dash: [5, 10]))
        .foregroundColor(.gray.opacity(0.5))
    }
}
