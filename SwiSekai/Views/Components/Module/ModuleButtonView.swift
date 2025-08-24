import SwiftUI

// module icon
struct ModuleIconView: View {
    let moduleName: String
    let status: ModuleStatus
    let isPressed: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            // The press animation is now handled by the custom ButtonStyle
            ModuleHexagonIcon(status: status, isPressed: isPressed)
            
            Text(moduleName)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
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

