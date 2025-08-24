import SwiftUI

struct SideBarView: View {
	@Binding var selection: NavigationItem
	@StateObject private var nav = NavigationStore()
	
	var body: some View {
		NavigationSplitView {
			VStack(alignment: .leading, spacing: 0) {
				
				Text("SwiSekai")
					.font(.title3)
					.fontWeight(.bold)
					.padding(.horizontal, 20)
					.padding(.top, 20)
					.padding(.bottom, 30)
				
				Text("Main")
					.font(.caption)
					.opacity(0.4)
					.padding(.leading, 14)
					.padding(.bottom, 7)
				
				VStack(alignment: .leading, spacing: 10) {
					ForEach(NavigationItem.allCases, id: \.self) { item in
						let isSelected = selection == item
						
						Button {
							selection = item
							nav.reset(item)
						} label: {
							HStack {
								Label(item.rawValue, systemImage: item.systemImage)
									.frame(maxWidth: .infinity, alignment: .leading)
							}
							.padding(.vertical, 10)
							.padding(.horizontal, 8)
							.contentShape(Rectangle())
						}
						.buttonStyle(.plain)
						.background(
							Group {
								if isSelected {
									RoundedRectangle(cornerRadius: 8)
										.fill(Color.white)
								}
							}
						)
						.foregroundStyle(isSelected ? .black : .white)
						.padding(.horizontal, 12)
						.accessibilityAddTraits(isSelected ? .isSelected : [])
					}
				}
				.padding(.top, 2)
				
				Spacer(minLength: 0)
			}
			.navigationSplitViewColumnWidth(180)
			.background(.projectsButtonOff)
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
