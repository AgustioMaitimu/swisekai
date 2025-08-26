import SwiftUI

struct TabBarView: View {
	@Binding var selection: NavigationItem
	@StateObject private var nav = NavigationStore()
	
	var body: some View {
		VStack(spacing: 0) {
			ZStack {
				// HOME
				if selection == .home {
					NavigationStack(path: $nav.homePath) {
						HomeScreen(selection: $selection)
					}
				}
				
				if selection == .learn {
					NavigationStack(path: $nav.learnPath) {
						ModulesView()
					}
				}
				
				if selection == .projects {
					NavigationStack(path: $nav.projectsPath) {
						ProjectsView()
					}
				}
			}
			.onChange(of: selection) { newValue in
				nav.reset(newValue)
			}
			
			HStack(spacing: 0) {
				TabButton(
					title: NavigationItem.home.rawValue,
					systemImage: NavigationItem.home.systemImage,
					isSelected: selection == .home
				) {
					selection = .home
					nav.reset(.home)
				}
				
				TabButton(
					title: NavigationItem.learn.rawValue,
					systemImage: NavigationItem.learn.systemImage,
					isSelected: selection == .learn
				) {
					selection = .learn
					nav.reset(.learn)
				}
				
				TabButton(
					title: NavigationItem.projects.rawValue,
					systemImage: NavigationItem.projects.systemImage,
					isSelected: selection == .projects
				) {
					selection = .projects
					nav.reset(.projects)
				}
			}
			.padding(.vertical, 8)
			.background(.tabBarBackground)
		}
	}
}

private struct TabButton: View {
	let title: String
	let systemImage: String
	let isSelected: Bool
	let action: () -> Void
	
	var body: some View {
		Button(action: action) {
			VStack(spacing: 4) {
				Image(systemName: systemImage)
					.font(.system(size: 16, weight: .semibold))
				Text(title)
					.font(.caption2)
			}
			.frame(maxWidth: .infinity)
			.padding(.vertical, 6)
			.contentShape(Rectangle())
			.opacity(isSelected ? 1.0 : 0.7)
		}
		.buttonStyle(.plain)
	}
}

#Preview {
	TabBarView(selection: .constant(.home))
		.frame(width: 400, height: 500)
}
