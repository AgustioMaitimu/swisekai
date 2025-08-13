//
//  LevelView.swift
//  SwiSekai
//
//  Created by Adrian Yusufa Rachman on 12/08/25.
//

import SwiftUI

// MARK: - Reusable Views for LevelView

struct ChapterButton: View {
    @State private var isPressed = false

    var body: some View {
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
            .frame(width: 453, height: 83)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.99, green: 0.76, blue: 0.47),
                        Color(red: 0.98, green: 0.29, blue: 0.13)
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

struct ModuleHexagonIcon: View {
    let iconName: String
    let isPressed: Bool

    var body: some View {
        ZStack {
            RoundedPolygonShape(sides: 6, cornerRadius: 10)
                .fill(Color(red: 0.35, green: 0.78, blue: 0.96))
                .frame(width: 140, height: 140)
                .rotationEffect(.degrees(30))
                .shadow(color: Color(red: 0.21, green: 0.5, blue: 0.61),
                        radius: 0,
                        x: 0,
                        y: isPressed ? 2 : 6)
                .offset(y: isPressed ? 4 : 0)
                .animation(.easeOut(duration: 0.1), value: isPressed)
            
            Image(systemName: iconName)
                .font(.system(size: 50, weight: .medium))
                .foregroundColor(.white)
                .offset(y: isPressed ? 4 : 0)
                .animation(.easeOut(duration: 0.1), value: isPressed)
        }
    }
}

struct ModuleIconView: View {
    let moduleName: String
    let iconName: String
    @State private var isPressed = false
    
    var body: some View {
        VStack(spacing: 8) {
            Button(action: { print("\(moduleName) tapped") }) {
                ModuleHexagonIcon(iconName: iconName, isPressed: isPressed)
            }
            .buttonStyle(.plain)
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in withAnimation(.easeOut(duration: 0.1)) { isPressed = true } }
                    .onEnded { _ in withAnimation(.easeOut(duration: 0.1)) { isPressed = false } }
            )
            
            Text(moduleName)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
        }
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
                    .rotationEffect(.degrees(45))
                
                Image("QuizIconBlue")
            }
            .frame(width: 90, height: 140)

            Text("Quiz")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
        }
    }
}

// ✅ Helper view for the sine path to keep body light
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

// MARK: - Main Level View

struct LevelView: View {
    var collections = DataManager.shared.moduleCollection.modules
    var quizzes = ["balls", "squares", "triangles"]
    
    let waveAmplitude: CGFloat = 180
    let verticalSpacing: CGFloat = 230
   
    var body: some View {
        let itemCount = collections.count
        let totalHeight = verticalSpacing * CGFloat(max(itemCount - 1, 1))
        let cycleCount = CGFloat(max((itemCount - 1) / 2, 1))
        let waveFrequency = cycleCount * (2 * .pi) / (totalHeight / verticalSpacing)
        
        let positions = insertQuizzes(between: peakTroughPositions(maxHeight: totalHeight, waveFrequency: waveFrequency))
        
        ScrollView {
            Spacer().frame(height: 30)
            ChapterButton()
            
            ZStack {
                GeometryReader { geo in
                    SinePathView(
                        verticalSpacing: verticalSpacing,
                        waveAmplitude: waveAmplitude,
                        waveFrequency: waveFrequency,
                        totalHeight: totalHeight
                    )
                    .offset(x: geo.size.width / 2, y: 50)
                }
                
                GeometryReader { geo in
                    ForEach(positions.indices, id: \.self) { i in
                        positionView(for: positions[i], geo: geo, waveFrequency: waveFrequency)
                    }
                }
            }
            .frame(height: totalHeight + 100)
            .padding(.top, 200)
        }
        .background(Color(red: 40/255, green: 42/255, blue: 47/255))
    }
    
    /// Breaks out the per-item view so the compiler has less work and generic types are erased.
    private func positionView(for pos: (y: CGFloat, isPeak: Bool, isQuiz: Bool, index: Int),
                              geo: GeometryProxy,
                              waveFrequency: CGFloat) -> some View {
        let xOffset = waveAmplitude * sin((pos.y / verticalSpacing) * waveFrequency)
        
        // Erase differing generic Button<Label> types into AnyView to avoid inference errors.
        let content: AnyView
        if pos.isQuiz {
            content = AnyView(
                Button(action: { print("Tapped Quiz") }) {
                    QuizIconView()
                }
                .buttonStyle(.plain)
            )
        } else {
            let collection = collections[pos.index % max(collections.count, 1)]
            let testIcons = ["swift", "book", "pencil", "star", "globe", "bolt.fill"]
            content = AnyView(
                Button(action: { print("Tapped \(collection.moduleName)") }) {
                    ModuleIconView(
                        moduleName: collection.moduleName,
                        iconName: testIcons.randomElement() ?? "swift"
                    )
                }
                .buttonStyle(.plain)
            )
        }
        
        return content
            .position(x: geo.size.width / 2 + xOffset, y: pos.y + 50)
    }

    private func peakTroughPositions(maxHeight: CGFloat, waveFrequency: CGFloat) -> [(y: CGFloat, isPeak: Bool)] {
        var positions: [(y: CGFloat, isPeak: Bool)] = []
        positions.append((y: -130, isPeak: true))
        var n = 0
        while true {
            let yPeak = verticalSpacing / waveFrequency * (.pi / 2 + 2 * .pi * CGFloat(n))
            if yPeak <= maxHeight { positions.append((y: yPeak, isPeak: true)) } else { break }
            let yTrough = verticalSpacing / waveFrequency * (3 * .pi / 2 + 2 * .pi * CGFloat(n))
            if yTrough <= maxHeight { positions.append((y: yTrough, isPeak: false)) } else { break }
            n += 1
        }
        return positions.sorted { $0.y < $1.y }
    }

    private func insertQuizzes(between positions: [(y: CGFloat, isPeak: Bool)]) -> [(y: CGFloat, isPeak: Bool, isQuiz: Bool, index: Int)] {
        var result: [(y: CGFloat, isPeak: Bool, isQuiz: Bool, index: Int)] = []
        var moduleIndex = 0
        for i in 0..<positions.count {
            result.append((y: positions[i].y, isPeak: positions[i].isPeak, isQuiz: false, index: moduleIndex))
            moduleIndex += 1
            if i < positions.count - 1 {
                let midY = (positions[i].y + positions[i+1].y) / 2
                result.append((y: midY, isPeak: false, isQuiz: true, index: -1))
            }
        }
        return result
    }
}

// MARK: - Shapes and Previews

struct RoundedPolygonShape: Shape {
    var sides: Int
    var cornerRadius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        guard sides >= 3 else { return Path() }
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        let angle = (2 * .pi) / CGFloat(sides)
        let radius = min(rect.width, rect.height) / 2 - cornerRadius
        var points: [CGPoint] = []
        for i in 0..<sides {
            let x = center.x + radius * cos(CGFloat(i) * angle - .pi / 2)
            let y = center.y + radius * sin(CGFloat(i) * angle - .pi / 2)
            points.append(CGPoint(x: x, y: y))
        }
        
        var path = Path()
        for i in 0..<sides {
            let prev = points[(i - 1 + sides) % sides]
            let current = points[i]
            let next = points[(i + 1) % sides]
            let prevVector = CGVector(dx: current.x - prev.x, dy: current.y - prev.y)
            let nextVector = CGVector(dx: next.x - current.x, dy: next.y - current.y)
            let prevLength = sqrt(prevVector.dx * prevVector.dx + prevVector.dy * prevVector.dy)
            let nextLength = sqrt(nextVector.dx * nextVector.dx + nextVector.dy * nextVector.dy)
            let start = CGPoint(x: current.x - prevVector.dx / prevLength * cornerRadius, y: current.y - prevVector.dy / prevLength * cornerRadius)
            let end = CGPoint(x: current.x + nextVector.dx / nextLength * cornerRadius, y: current.y + nextVector.dy / nextLength * cornerRadius)
            
            if i == 0 { path.move(to: start) } else { path.addLine(to: start) }
            path.addQuadCurve(to: end, control: current)
        }
        path.closeSubpath()
        return path
    }
}

#Preview {
    LevelView()
}
