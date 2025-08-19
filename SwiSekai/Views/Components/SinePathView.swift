//import SwiftUI
//
////  Helper view for the sine path
//struct SinePathView: View {
//    let verticalSpacing: CGFloat
//    let waveAmplitude: CGFloat
//    let waveFrequency: CGFloat
//    let totalHeight: CGFloat
//    
//    var body: some View {
//        Path { path in
//            path.move(to: .zero)
//            
//            for y in stride(from: 0, through: totalHeight, by: 1) {
//                let x = sin(y / verticalSpacing * waveFrequency) * waveAmplitude
//                path.addLine(to: CGPoint(x: x, y: y))
//            }
//        }
//        .stroke(Color.white, lineWidth: 3) // 👈 without this, nothing is drawn
//    }
//}
//
