import SwiftUI

struct SideBarView: View {
	@Binding var selection: NavigationItem
	@StateObject private var nav = NavigationStore()
	
	var body: some View {
		NavigationSplitView {
			VStack(alignment: .leading, spacing: 0) {
				Image("SidebarIcon")
					.padding(.horizontal, 5)
					.padding(.top, 20)
					.padding(.bottom, 30)
                    .accessibilityLabel(Text("Sidebar Icon"))
				
				Text("MAIN")
					.font(.caption)
					.opacity(0.4)
					.padding(.leading, 14)
					.padding(.bottom, 7)
				
				List(NavigationItem.allCases, id: \.self, selection: $selection) { item in
					let isSelected = selection == item
					HStack {
						Label(item.rawValue, systemImage: item.systemImage)
						Spacer(minLength: 0)
					}
					.listRowBackground(Color.projectsButtonOff)
					.foregroundStyle(isSelected ? .black : .white)
					.padding(.vertical, 14)
					.padding(.leading, 18)
					.background(isSelected ? .white : .clear)
					.clipShape(.rect(cornerRadius: 8))
					.onTapGesture {
						selection = item
						nav.reset(item)
					}
					.listRowSeparator(.hidden)
				}
				.listStyle(.plain)
				.scrollContentBackground(.hidden)
			}
			.padding(.horizontal, 12)
			.background(.projectsButtonOff)
			.navigationSplitViewColumnWidth(220)
		} detail: {
			ZStack {
				if selection == .home {
					NavigationStack(path: $nav.homePath) {
						HomeScreen(selection: $selection)
					}
                    .accessibilityHint(Text("Go to Home"))
				}
				
				if selection == .learn {
					NavigationStack(path: $nav.learnPath) {
						ModulesView()
					}
                    .accessibilityHint(Text("Go to Learn"))
				}
				
				if selection == .projects {
					NavigationStack(path: $nav.projectsPath) {
						ProjectsView()
					}
                    .accessibilityHint(Text("Go to Projects"))
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
