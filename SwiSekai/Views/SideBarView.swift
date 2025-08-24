import SwiftUI

struct SideBarView: View {
	@Binding var selection: NavigationItem
	@StateObject private var nav = NavigationStore()
	
	var body: some View {
		NavigationSplitView {
			List(NavigationItem.allCases, id: \.self, selection: $selection) { item in
				let isSelected = selection == item
				HStack {
					Label(item.rawValue, systemImage: item.systemImage)
					Spacer(minLength: 0)
				}
				.foregroundStyle(isSelected ? .black : .white)
				.padding(.vertical, 10)
				.padding(.horizontal, 8)
				.onTapGesture {
					selection = item
					nav.reset(item)
				}
			}
			.listStyle(.sidebar)
			.background(.projectsButtonOff)
			.scrollContentBackground(.hidden)
		} detail: {
			ZStack {
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
		}
	}
}

#Preview {
	SideBarView(selection: .constant(.home))
		.frame(width: 320, height: 500)
}
