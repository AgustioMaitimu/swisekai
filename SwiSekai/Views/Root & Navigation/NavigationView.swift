import SwiftUI

struct NavigationView: View {
	@Binding var selection: NavigationItem
	@StateObject private var nav = NavigationStore()
	
	var body: some View {
		GeometryReader { geometry in
			HStack(spacing: 0) {
				
				if geometry.size.width > 900 {
					SideBarComponent(selection: $selection)
				}
				
				// Content
				VStack {
					if selection == .home {
						NavigationStack(path: $nav.homePath) {
							HomeScreen(selection: $selection)
						}
						.accessibilityHint(Text("Go to Home"))
					} else if selection == .learn {
						NavigationStack(path: $nav.learnPath) {
							ModulesView()
						}
						.accessibilityHint(Text("Go to Learn"))
					} else if selection == .projects {
						NavigationStack(path: $nav.projectsPath) {
							ProjectsView()
						}
						.accessibilityHint(Text("Go to Projects"))
					}
					
					if geometry.size.width < 900 {
						TabBarComponent(selection: $selection)
					}
				}
				.onChange(of: selection) { newValue in
					nav.reset(newValue)
				}
				.frame(maxWidth: .infinity, maxHeight: .infinity)
			}
		}
		.ignoresSafeArea()
	}
}

#Preview {
	SideBarView(selection: .constant(.home))
		.frame(width: 320, height: 500)
}
