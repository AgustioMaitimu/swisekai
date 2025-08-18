import SwiftUI

struct TabBarView: View {
    @Binding var selection: NavigationItem

    var body: some View {
        VStack(spacing: 0) {
            // Main content
            Group {
                switch selection {
                case .home:
                    Text("🏠 Home").font(.largeTitle)
                case .learn:
                    ModulesView()
                case .projects:
                    ProjectsView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity) // take all space
            .background(Color.gray.opacity(0.1))

            // Tab bar at bottom
            HStack {
                TabBarButton(icon: "house", title: "Home", isSelected: selection == .home) {
                    selection = .home
                }
                Spacer()
                TabBarButton(icon: "book", title: "Learn", isSelected: selection == .learn) {
                    selection = .learn
                }
                Spacer()
                TabBarButton(icon: "bolt.horizontal", title: "Projects", isSelected: selection == .projects) {
                    selection = .projects
                }
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 30)
            .background(Color(NSColor.windowBackgroundColor))
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(Color.gray.opacity(0.3)),
                alignment: .top
            )
        }
    }
}

struct TabBarButton: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                Text(title)
                    .font(.caption)
            }
            .foregroundStyle(
                            isSelected
                            ? AnyShapeStyle(selectedGradient)
                            : AnyShapeStyle(.secondary)
                        )
            .padding(.vertical, 5)
        }
        .buttonStyle(.plain)
    }
    
    private var selectedGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color(red: 0xFC/255, green: 0xC2/255, blue: 0x79/255), // #FCC279
                Color(red: 0xFB/255, green: 0x4B/255, blue: 0x22/255)  // #FB4B22
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }
}


#Preview {
    TabBarView(selection: .constant(.home))
        .frame(width: 400, height: 500)
}
