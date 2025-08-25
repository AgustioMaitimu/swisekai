import SwiftUI

struct SideBarView: View {
	@Binding var selection: NavigationItem
	@StateObject private var nav = NavigationStore()
	
	var body: some View {
		GeometryReader { geometry in
			HStack(spacing: 0) {
				
				if geometry.size.width > 900 {
					VStack(alignment: .leading, spacing: 0) {
						HStack(alignment: .center, spacing: 8) {
							VStack(spacing: -4) {
								Text("スイ")
									.font(.title)
								Text("せかい")
							}
							Text("SwiSekai")
								.font(.title.bold())
							
						}
						.foregroundStyle(.white)
						.padding(.horizontal, 20)
						.padding(.top, 60)
						.padding(.bottom, 32)
						
						Text("Main")
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
					.frame(width: 250) // Fixed width
					.background(.projectsButtonOff)
					.clipShape(
						UnevenRoundedRectangle(bottomTrailingRadius: 28, topTrailingRadius: 28)
					)
					.shadow(color: .black.opacity(0.05), radius: 8, x: 4, y: 0)				}
				
				// Content
				VStack {
					if selection == .home {
						NavigationStack(path: $nav.homePath) {
							HomeScreen(selection: $selection)
						}
					} else if selection == .learn {
						NavigationStack(path: $nav.learnPath) {
							ModulesView()
						}
					} else if selection == .projects {
						NavigationStack(path: $nav.projectsPath) {
							ProjectsView()
						}
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
	SideBarView(selection: .constant(.home))
		.frame(width: 320, height: 500)
}



//import SwiftUI
//
//struct SideBarView: View {
//	@Binding var selection: NavigationItem
//	@StateObject private var nav = NavigationStore()
//
//	var body: some View {
//		GeometryReader { geometry in
//			HStack(spacing: 0) {
//				VStack(alignment: .leading, spacing: 0) {
//					HStack(alignment: .center, spacing: 8) {
//						VStack(spacing: -4) {
//							Text("スイ")
//								.font(.title)
//							Text("せかい")
//						}
//						Text("SwiSekai")
//							.font(.title.bold())
//
//					}
//					.foregroundStyle(.white)
//					.padding(.horizontal, 20)
//					.padding(.top, 60)
//					.padding(.bottom, 32)
//
//					Text("Main")
//						.font(.caption)
//						.opacity(0.4)
//						.padding(.leading, 14)
//						.padding(.bottom, 7)
//
//					List(NavigationItem.allCases, id: \.self, selection: $selection) { item in
//						let isSelected = selection == item
//						HStack {
//							Label(item.rawValue, systemImage: item.systemImage)
//							Spacer(minLength: 0)
//						}
//						.listRowBackground(Color.projectsButtonOff)
//						.foregroundStyle(isSelected ? .black : .white)
//						.padding(.vertical, 14)
//						.padding(.leading, 18)
//						.background(isSelected ? .white : .clear)
//						.clipShape(.rect(cornerRadius: 8))
//						.onTapGesture {
//							selection = item
//							nav.reset(item)
//						}
//						.listRowSeparator(.hidden)
//					}
//					.listStyle(.plain)
//					.scrollContentBackground(.hidden)
//				}
//				.padding(.horizontal, 12)
//				.frame(width: 250) // Fixed width
//				.background(.projectsButtonOff)
//				.clipShape(
//					UnevenRoundedRectangle(bottomTrailingRadius: 28, topTrailingRadius: 28)
//				)
//				.shadow(color: .black.opacity(0.05), radius: 8, x: 4, y: 0)
//
//				// Content
//				VStack {
//					ZStack {
//						if selection == .home {
//							NavigationStack(path: $nav.homePath) {
//								HomeScreen(selection: $selection)
//							}
//						}
//
//						if selection == .learn {
//							NavigationStack(path: $nav.learnPath) {
//								ModulesView()
//							}
//						}
//
//						if selection == .projects {
//							NavigationStack(path: $nav.projectsPath) {
//								ProjectsView()
//							}
//						}
//					}
//					.onChange(of: selection) { newValue in
//						nav.reset(newValue)
//					}
//				}
//				.frame(maxWidth: .infinity, maxHeight: .infinity)
//			}
//		}
//		.ignoresSafeArea()
//	}
//}
//
//private struct TabButton: View {
//	let title: String
//	let systemImage: String
//	let isSelected: Bool
//	let action: () -> Void
//
//	var body: some View {
//		Button(action: action) {
//			VStack(spacing: 4) {
//				Image(systemName: systemImage)
//					.font(.system(size: 16, weight: .semibold))
//				Text(title)
//					.font(.caption2)
//			}
//			.frame(maxWidth: .infinity)
//			.padding(.vertical, 6)
//			.contentShape(Rectangle())
//			.opacity(isSelected ? 1.0 : 0.7)
//		}
//		.buttonStyle(.plain)
//	}
//}
//
//#Preview {
//	SideBarView(selection: .constant(.home))
//		.frame(width: 320, height: 500)
//}
