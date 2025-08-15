//
//  LevelView.swift
//  SwiSekai
//
//  Created by Adrian Yusufa Rachman on 12/08/25.
//

import SwiftUI

// MARK: - Main Level View
struct ModulesView: View {
    // MARK: - Data
    // Gets module data from database
    var collections = DataManager.shared.moduleCollection.modules
    var highestCompletedLevel: Int = 4
    
    // Placeholder quiz names (TODO: Replace with DB data later)
    var quizzes = ["balls", "squares", "triangles"]
    
    // MARK: - Wave Settings
    let waveAmplitude: CGFloat = 180       // Horizontal distance from wave center to peak
    let verticalSpacing: CGFloat = 230     // Vertical distance between peaks/troughs
    
    var body: some View {
        // MARK: - Wave Calculations
        let itemCount = collections.count
        
        // Total height of the scrollable area (modules + some extra space)
        let totalHeight = verticalSpacing * CGFloat(max(itemCount + 2, 1))
        
        // Number of sine wave cycles to draw based on item count
        let cycleCount = CGFloat(max((itemCount - 1) / 2, 1))
        
        // Frequency of the sine wave (controls how "stretched" it is vertically)
        let waveFrequency = cycleCount * (2 * .pi) / (totalHeight / verticalSpacing)
        
        // Generate positions for modules & quizzes
        let positions = insertQuizzes(
            between: peakTroughPositions(
                maxHeight: totalHeight,
                waveFrequency: waveFrequency
            )
        )
        
        // MARK: - Main UI
        ScrollView {
            Spacer().frame(height: 30) // Top margin
            ChapterButton()
            
            ZStack {
                // Uncomment if you want to draw the sine path background
                /*
                GeometryReader { geo in
                    SinePathView(
                        verticalSpacing: verticalSpacing,
                        waveAmplitude: waveAmplitude,
                        waveFrequency: waveFrequency,
                        totalHeight: totalHeight
                    )
                    .offset(x: geo.size.width / 2, y: 50)
                }
                */
                
                GeometryReader { geo in
                    // Place each module/quiz on the sine wave
                    ForEach(positions.indices, id: \.self) { i in
                        positionView(
                            for: positions[i],
                            geo: geo,
                            waveFrequency: waveFrequency
                        )
                    }
                    
                    // Place the final test button at the end of the sine wave
                    if let lastPos = positions.last {
                        let finalYOffset = lastPos.y + verticalSpacing // Push below last item
                        let finalXOffset = waveAmplitude * sin((finalYOffset / verticalSpacing) * waveFrequency)
                        
                        FinalTestButton()
                            .position(
                                x: geo.size.width / 2 + finalXOffset,
                                y: finalYOffset + 20
                            )
                    }
                }
            }
            .frame(height: totalHeight + 100)
            .padding(.top, 200)
            .padding(.bottom, 100)
        }
        .background(Color(red: 40/255, green: 42/255, blue: 47/255)) // Dark gray background
    }
    
    // MARK: - Helper: Positioning Individual Items
    private func positionView(
        for pos: (y: CGFloat, isPeak: Bool, isQuiz: Bool, index: Int),
        geo: GeometryProxy,
        waveFrequency: CGFloat
    ) -> some View {
        
        // X offset from sine wave formula
        let xOffset = waveAmplitude * sin((pos.y / verticalSpacing) * waveFrequency)
        
        // Use AnyView to erase different Button types (avoids generic type inference errors)
        let content: AnyView
        
        if pos.isQuiz {
            // Quiz Button
            content = AnyView(
                Button(action: { print("Tapped Quiz") }) {
                    QuizIconView()
                }
                .buttonStyle(.plain)
            )
        } else {
            // Module Button
            let collection = collections[pos.index % max(collections.count, 1)]
            let testIcons = ["swift", "book", "pencil", "star", "globe", "bolt.fill"] // placeholder icons
            
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
            .position(
                x: geo.size.width / 2 + xOffset,
                y: pos.y + 50
            )
    }

    // MARK: - Helper: Generate peak & trough Y positions of sine wave
    private func peakTroughPositions(maxHeight: CGFloat, waveFrequency: CGFloat)
        -> [(y: CGFloat, isPeak: Bool)]
    {
        var positions: [(y: CGFloat, isPeak: Bool)] = []
        
        // First peak starts a bit above zero
        positions.append((y: -130, isPeak: true))
        
        var n = 0
        while true {
            // Peak position
            let yPeak = verticalSpacing / waveFrequency * (.pi / 2 + 2 * .pi * CGFloat(n))
            if yPeak <= maxHeight {
                positions.append((y: yPeak, isPeak: true))
            } else { break }
            
            // Trough position
            let yTrough = verticalSpacing / waveFrequency * (3 * .pi / 2 + 2 * .pi * CGFloat(n))
            if yTrough <= maxHeight {
                positions.append((y: yTrough, isPeak: false))
            } else { break }
            
            n += 1
        }
        
        // Sort so we draw from top to bottom
        return positions.sorted { $0.y < $1.y }
    }

    // MARK: - Helper: Insert quizzes between peaks & troughs
    private func insertQuizzes(
        between positions: [(y: CGFloat, isPeak: Bool)]
    ) -> [(y: CGFloat, isPeak: Bool, isQuiz: Bool, index: Int)] {
        
        var result: [(y: CGFloat, isPeak: Bool, isQuiz: Bool, index: Int)] = []
        var moduleIndex = 0
        
        for i in 0..<positions.count {
            // Add a module at the peak or trough
            result.append((y: positions[i].y, isPeak: positions[i].isPeak, isQuiz: false, index: moduleIndex))
            moduleIndex += 1
            
            // Add a quiz halfway between two positions
            if i < positions.count - 1 {
                let midY = (positions[i].y + positions[i+1].y) / 2
                result.append((y: midY, isPeak: false, isQuiz: true, index: -1))
            }
        }
        
        return result
    }
} // end of LevelView





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


// module icon


struct ModuleIconView: View {
    
    
    let moduleName: String
    let iconName: String
    @State private var isPressed = false
    
    var body: some View {
        VStack(spacing: 8) {
            Button(action: { print("\(moduleName) tapped") }) {
                ModuleHexagonIcon(status: .finished, isPressed: isPressed)
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
                .lineLimit(2) // Allow up to 2 lines
                .fixedSize(horizontal: false, vertical: true) // Wrap vertically
                .frame(width: 150) // match icon width

        }
    }
}

enum ModuleStatus {
    case finished
    case current
    case unavailable
}

struct ModuleHexagonIcon: View {
    let status: ModuleStatus
    let isPressed: Bool

    var body: some View {
        ZStack {
            // Background Shape
            RoundedPolygonShape(sides: 6, cornerRadius: 10)
                .fill(backgroundFill)
                .frame(width: 140, height: 140)
                .rotationEffect(.degrees(30))
                .shadow(color: shadowColor,
                        radius: 0,
                        x: 0,
                        y: isPressed ? 2 : 6)
                .offset(y: isPressed ? 4 : 0)
                .animation(.easeOut(duration: 0.1), value: isPressed)
            
            // Icon
            Image(systemName: symbolName)
                .font(.system(size: 50, weight: .medium))
                .foregroundColor(.white)
                .offset(y: isPressed ? 4 : 0)
                .animation(.easeOut(duration: 0.1), value: isPressed)
        }
    }
    
    // MARK: - Computed Styles
    private var backgroundFill: AnyShapeStyle {
        switch status {
        case .finished:
            return AnyShapeStyle(Color(red: 0.35, green: 0.78, blue: 0.96)) // Your original blue
        case .current:
            return AnyShapeStyle(
                LinearGradient(
                    stops: [
                        Gradient.Stop(color: Color(red: 0.99, green: 0.76, blue: 0.47), location: 0.00),
                        Gradient.Stop(color: Color(red: 0.98, green: 0.29, blue: 0.13), location: 1.00)
                    ],
                    startPoint: UnitPoint(x: 0.5, y: 0),
                    endPoint: UnitPoint(x: 0.5, y: 1)
                )
            )
        case .unavailable:
            return AnyShapeStyle(Color(red: 0.85, green: 0.85, blue: 0.85)) // #D9D9D9
        }
    }

    
    private var shadowColor: Color {
        switch status {
        case .finished:
            return Color(red: 0.21, green: 0.5, blue: 0.61)
        case .current:
            return Color(red: 0.49, green: 0.15, blue: 0.06)
        case .unavailable:
            return Color(red: 0.42, green: 0.42, blue: 0.42) // #6B6B6B
        }
    }
    
    private var symbolName: String {
        switch status {
        case .finished:
            return "checkmark"
        case .current:
            return "book"
        case .unavailable:
            return "lock"
        }
    }
}




// quiz icon
enum QuizStatus {
    case available
    case unavailable
}

struct QuizIconView: View {
    var status: QuizStatus = .unavailable // placeholder until database logic comes in
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 90, height: 90)
                    .background(status == .available
                                ? Color(red: 0, green: 0.66, blue: 0.93) // Blue
                                : Color(red: 0.65, green: 0.65, blue: 0.65)) // Gray
                    .cornerRadius(10)
                    .rotationEffect(.degrees(45))
                
                Image(status == .available ? "QuizIconBlue" : "QuizIconGray")
            }
            .frame(width: 90, height: 140)

            Text("Quiz")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
        }
    }
}


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


// shape for rounded polygons

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


// Final Test button


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


#Preview {
    ModulesView()
}
