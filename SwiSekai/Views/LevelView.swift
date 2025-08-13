//
//  LevelView.swift
//  SwiSekai
//
//  Created by Adrian Yusufa Rachman on 12/08/25.
//

import SwiftUI


struct LevelView: View {
    var collections = DataManager.shared.moduleCollection.modules
    var quizzes = ["balls", "squares", "triangles"]
    
    // Wave Parameters
    let waveAmplitude: CGFloat = 180
    let waveFrequency: CGFloat = 1.5
    let verticalSpacing: CGFloat = 230
    @State private var isPressed = false
   

    var body: some View {
        let itemCount = collections.count
        let totalHeight = verticalSpacing * CGFloat(itemCount - 1)
        
        // Calculate wave frequency so that we have exactly enough peaks/troughs
        let cycleCount = CGFloat((itemCount - 1) / 2)
        let waveFrequency = cycleCount * (2 * .pi) / (totalHeight / verticalSpacing)
        
        // Original peaks/troughs
        let basePositions = peakTroughPositions(maxHeight: totalHeight, waveFrequency: waveFrequency)
        
        // Insert quizzes between each
        let positions = insertQuizzes(between: basePositions)
        
        

        ScrollView {
            
            Spacer().frame(height: 30)
            Button(action: {
                print("Pressed")
            }) {
                HStack {
                    Image(systemName: "book.pages")
                        .font(.system(size: 45))
                    
                    VStack(alignment: .leading) {
                        Text("Chapter 1, Unit 1")
                            .font(Font.custom("SF Pro", size: 17))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                        
                        Text("Swift Datatype")
                            .font(Font.custom("SF Pro", size: 24).weight(.bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                    }
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 30))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 0)
                .frame(width: 453, height: 83, alignment: .center)
                .background(
                    LinearGradient(
                        gradient: Gradient(stops: [
                            Gradient.Stop(color: Color(red: 0.99, green: 0.76, blue: 0.47), location: 0.00),
                            Gradient.Stop(color: Color(red: 0.98, green: 0.29, blue: 0.13), location: 1.00),
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .cornerRadius(20)
                .shadow(
                    color: Color(red: 164/255, green: 61/255, blue: 31/255),
                    radius: 0,
                    x: 0,
                    y: isPressed ? 2 : 6 // reduced shadow when pressed
                )
                .offset(y: isPressed ? 4 : 0) // push down a bit
                .animation(.easeOut(duration: 0.1), value: isPressed)
            }
            .buttonStyle(PlainButtonStyle()) // remove default SwiftUI tap effect
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        withAnimation(.easeOut(duration: 0.1)) {
                            isPressed = true
                        }
                    }
                    .onEnded { _ in
                        withAnimation(.easeOut(duration: 0.1)) {
                            isPressed = false
                        }
                    }
            )
        
                
         
            ZStack {
              
                GeometryReader { geo in
                    sinePath(for: geo, waveFrequency: waveFrequency)
                        .frame(width: geo.size.width)
                }
              
                GeometryReader { geo in
                    ForEach(0..<positions.count, id: \.self) { i in
                        let pos = positions[i]
                        let isQuiz = pos.isQuiz
                        let xOffset = waveAmplitude * sin((pos.y / verticalSpacing) * waveFrequency)

                        if isQuiz {
                            // Quiz button
                            Button(action: {
                                print("Tapped Quiz")
                            }) {
                                QuizIconView()
                            }
                            .buttonStyle(PlainButtonStyle())
                            .position(
                                x: geo.size.width / 2 + xOffset,
                                y: pos.y + 50
                            )
                        } else {
                            // Module button
                            let collection = collections[pos.index % collections.count]
                            let testIcons = ["swift", "book", "pencil", "star", "globe", "bolt.fill"] //placeholder

                            Button(action: {
                                print("Tapped \(collection.module_name)")
                            }) {
                                ModuleIconView(
                                    moduleName: collection.module_name,
                                    iconName: testIcons.randomElement() ?? "swift"
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                            .position(
                                x: geo.size.width / 2 + xOffset,
                                y: pos.y + 50
                            )
                        }
                    }
                }
            }
            .frame(height: totalHeight + 100)
            .padding(.top,200)
        }
        .background(Color(red: 40/255, green: 42/255, blue: 47/255))

    }



    /// Compute Y positions where the sine reaches ±1 (peaks and troughs),
    /// using the same argument mapping: sinArg = (y / verticalSpacing) * waveFrequency
    private func peakTroughPositions(maxHeight: CGFloat, waveFrequency: CGFloat) -> [(y: CGFloat, isPeak: Bool)] {
        var positions: [(y: CGFloat, isPeak: Bool)] = []
        positions.append((y: -130, isPeak: true)) // start at top

        var n = 0
        while true {
            let yPeak = verticalSpacing / waveFrequency * (CGFloat.pi / 2 + 2 * .pi * CGFloat(n))
            if yPeak <= maxHeight {
                positions.append((y: yPeak, isPeak: true))
            } else { break }

            let yTrough = verticalSpacing / waveFrequency * (3 * .pi / 2 + 2 * .pi * CGFloat(n))
            if yTrough <= maxHeight {
                positions.append((y: yTrough, isPeak: false))
            } else { break }

            n += 1
        }

        positions.sort { $0.y < $1.y }
        return positions
    }


    private func insertQuizzes(between positions: [(y: CGFloat, isPeak: Bool)]) -> [(y: CGFloat, isPeak: Bool, isQuiz: Bool, index: Int)] {
        var result: [(y: CGFloat, isPeak: Bool, isQuiz: Bool, index: Int)] = []
        var moduleIndex = 0

        for i in 0..<positions.count {
            // Add the original module position
            result.append((y: positions[i].y, isPeak: positions[i].isPeak, isQuiz: false, index: moduleIndex))
            moduleIndex += 1

            // If not the last one, add a quiz halfway
            if i < positions.count - 1 {
                let midY = (positions[i].y + positions[i+1].y) / 2
                result.append((y: midY, isPeak: false, isQuiz: true, index: -1))
            }
        }
        return result
    }


    private func sinePath(for geo: GeometryProxy, waveFrequency: CGFloat) -> some View {
        Path { path in
            let totalHeight = verticalSpacing * CGFloat(collections.count - 1)
            path.move(to: CGPoint(x: waveAmplitude * sin(0), y: 0))

            let step: CGFloat = 0.5
            for y in stride(from: CGFloat(0), through: totalHeight, by: step) {
                let x = waveAmplitude * sin(y / verticalSpacing * waveFrequency)
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        .stroke(style: StrokeStyle(lineWidth: 0, dash: [5, 10]))
        .foregroundColor(.gray.opacity(0.5))
        .offset(x: geo.size.width / 2)
        .offset(y: 50)
    }

}

// ✅ Reusable custom icon+text view
struct ModuleIconView: View {
    let moduleName: String
    let iconName: String
    @State private var isPressed = false
    
    var body: some View {
        VStack(spacing: 8) {
            Button(action: {
                print("\(moduleName) tapped")
            }) {
                ZStack {
                    // Rounded hexagon
                    RoundedPolygonShape(sides: 6,cornerRadius: 10)
                        .fill(Color(red: 0.35, green: 0.78, blue: 0.96))
                        .frame(width: 140, height: 140)
                        .rotationEffect(.degrees(30))
                        .shadow(
                            color: Color(red: 0.21, green: 0.5, blue: 0.61),
                            radius: 0,
                            x: 0,
                            y: isPressed ? 2 : 6
                        )
                        .offset(y: isPressed ? 4 : 0)
                        .animation(.easeOut(duration: 0.1), value: isPressed)
                        
                    
                    Image(systemName: iconName)
                        .font(.system(size: 50, weight: .medium))
                        .foregroundColor(.white)
                        .offset(y: isPressed ? 4 : 0)
                        .animation(.easeOut(duration: 0.1), value: isPressed)
                }
            }
            .buttonStyle(PlainButtonStyle())
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        withAnimation(.easeOut(duration: 0.1)) {
                            isPressed = true
                        }
                    }
                    .onEnded { _ in
                        withAnimation(.easeOut(duration: 0.1)) {
                            isPressed = false
                        }
                    }
            )
            
            Text(moduleName)
                .font(.system(size: 22))
                .font(.headline.weight(.bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
        }
    }
}

// Custom rounded polygon shape

struct RoundedPolygonShape: Shape {
    var sides: Int
    var cornerRadius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        guard sides >= 3 else { return Path() }
        
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        let angle = (2 * .pi) / CGFloat(sides)
        let radius = min(rect.width, rect.height) / 2 - cornerRadius
        
        var path = Path()
        
        // Points for vertices
        var points: [CGPoint] = []
        for i in 0..<sides {
            let x = center.x + radius * cos(CGFloat(i) * angle - .pi / 2)
            let y = center.y + radius * sin(CGFloat(i) * angle - .pi / 2)
            points.append(CGPoint(x: x, y: y))
        }
        
        // Draw with rounded corners
        for i in 0..<sides {
            let prev = points[(i - 1 + sides) % sides]
            let current = points[i]
            let next = points[(i + 1) % sides]
            
            let prevVector = CGVector(dx: current.x - prev.x, dy: current.y - prev.y)
            let nextVector = CGVector(dx: next.x - current.x, dy: next.y - current.y)
            
            let prevLength = sqrt(prevVector.dx * prevVector.dx + prevVector.dy * prevVector.dy)
            let nextLength = sqrt(nextVector.dx * nextVector.dx + nextVector.dy * nextVector.dy)
            
            let start = CGPoint(
                x: current.x - prevVector.dx / prevLength * cornerRadius,
                y: current.y - prevVector.dy / prevLength * cornerRadius
            )
            
            let end = CGPoint(
                x: current.x + nextVector.dx / nextLength * cornerRadius,
                y: current.y + nextVector.dy / nextLength * cornerRadius
            )
            
            if i == 0 {
                path.move(to: start)
            } else {
                path.addLine(to: start)
            }
            
            path.addQuadCurve(to: end, control: current)
        }
        
        path.closeSubpath()
        return path
    }
}

struct QuizIconView: View {
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Rectangle()
                .foregroundColor(.clear)
                .frame(width: 90, height: 90)
                .background(Color(red: 0, green: 0.66, blue: 0.93))

                .cornerRadius(10)
                .rotationEffect(Angle(degrees: 45))
                   
                
                Image("QuizIconBlue")
            }
            .frame(width: 90, height: 140)

            Text("Quiz")
                .font(.system(size: 22))
                .font(.headline.weight(.bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
        }
    }
}





#Preview {
    LevelView()
}
