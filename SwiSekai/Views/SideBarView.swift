import SwiftUI

enum NavigationItem: String, CaseIterable, Identifiable {
    case home = "Home"
    case learn = "Learn"
    case projects = "Projects"

    var id: String { rawValue }

    var systemImage: String {
        switch self {
        case .home: return "house"
        case .learn: return "book"
        case .projects: return "bolt.horizontal"
        }
    }
}

struct SideBarView: View {
    @Binding var selection: NavigationItem

    var body: some View {
        NavigationSplitView {
            List(NavigationItem.allCases, id: \.self) { item in
                let isSelected = selection == item

                HStack {
                    Label(item.rawValue, systemImage: item.systemImage)
                    Spacer(minLength: 0)
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 8)
                .foregroundColor(isSelected ? .white : .gray)
                .background {
                    if isSelected {
                        RoundedRectangle(cornerRadius: 11)
                            .fill(
                                LinearGradient(
                                    stops: [
                                        .init(color: Color(red: 0.99, green: 0.25, blue: 0), location: 0.00),
                                        .init(color: Color(red: 1, green: 0.49, blue: 0.25), location: 1.00),
                                    ],
                                    startPoint: UnitPoint(x: 0.5, y: 0),
                                    endPoint: UnitPoint(x: 0.5, y: 1)
                                )
                            )
                    } else {
                        RoundedRectangle(cornerRadius: 11)
                            .fill(Color(red: 0.19, green: 0.20, blue: 0.21)) // #303236
                    }
                } // <-- important: closes the .background block
                .contentShape(Rectangle())
                .onTapGesture { selection = item }
                .animation(.easeInOut(duration: 0.15), value: isSelected)
            }
            .listStyle(.sidebar)
            .scrollContentBackground(.hidden) // apply to the List
            .background(Color(red: 0.19, green: 0.20, blue: 0.21))

            
            .navigationTitle("SwiSekai")
        } detail: {
            switch selection {
            case .home:
                Text("🏠 Home Content").font(.largeTitle)
            case .learn:
                ModulesView()
            case .projects:
                ProjectsView()
            }
        }
    }
}

#Preview {
    SideBarView(selection: .constant(.home))
        .frame(width: 320, height: 500)
}
