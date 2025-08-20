import SwiftUI
import SwiftData

class ProjectsUIState: ObservableObject {
	static let shared = ProjectsUIState()
	@Published var selectedProjectId: String?
	@Published var selectedCategory: String = "All"
}

struct ProjectsView: View {
	@Environment(\.modelContext) private var modelContext
	@Query private var userDataItems: [UserData]
	private var userData: UserData { userDataItems.first ?? UserData.shared(in: modelContext) }
	var projects = DataManager.shared.projectCollection.projects
	var modules = DataManager.shared.moduleCollection.modules
	
	@StateObject private var uiState = ProjectsUIState.shared
	@State private var unlockedSectionExpanded: Bool = true
	@State private var lockedSectionExpanded: Bool = true
	@State private var completedSectionExpanded: Bool = true
	
	@State private var unlockedExpanded = true
	@State private var lockedExpanded = false
	@State private var completedExpanded = false
	
	private var completedProjects: [Project] {
		projects
			.filter { userData.completedProjects.contains($0.id) }
			.sorted { $0.projectDifficulty < $1.projectDifficulty }
	}
	
	private var unlockedProjects: [Project] {
		projects
			.filter { $0.levelPrerequisite <= userData.highestCompletedLevel && !userData.completedProjects.contains($0.id) }
			.sorted { $0.projectDifficulty < $1.projectDifficulty }
	}
	
	private var lockedProjects: [Project] {
		projects
			.filter { $0.levelPrerequisite > userData.highestCompletedLevel }
			.sorted { $0.projectDifficulty > $1.projectDifficulty }
	}
	
	let activeGradient = LinearGradient(
		stops: [
			.init(color: Color(red: 0.99, green: 0.25, blue: 0), location: 0.00),
			.init(color: Color(red: 1, green: 0.49, blue: 0.25), location: 1.00),
		],
		startPoint: .top,
		endPoint: .bottom
	)
	
	var body: some View {
		GeometryReader { geometry in
			VStack(spacing: 0) {
				headerView(for: geometry.size.width)
				
				if geometry.size.width < 700 {
					verticalLayout(for: geometry.size.width)
				} else {
					HStack(alignment: .top) {
						Spacer()
						horizontalLayout(for: geometry.size.width)
						Spacer()
					}
				}
			}
			.padding(.horizontal, geometry.size.width < 910 ? 15 : 20)
			.padding(.vertical, 36)
			.background(Color("MainBackground"))
		}
		.onAppear {
			if uiState.selectedProjectId == nil {
				if let firstUnlocked = unlockedProjects.first {
					uiState.selectedProjectId = firstUnlocked.id.uuidString
				} else if let firstLocked = lockedProjects.first {
					uiState.selectedProjectId = firstLocked.id.uuidString
				}
			}
		}
	}
	
	private func headerView(for width: CGFloat) -> some View {
		HStack {
			VStack(alignment: .leading, spacing: 10) {
				Text("Projects")
					.font(width < 910 ? .title.bold() : .largeTitle.bold())
					.foregroundColor(.white)
				Text("Apply your Swift skills to real-world projects!")
					.font(width < 910 ? .title3.bold() : .title2.bold())
					.foregroundColor(Color(red: 0.85, green: 0.85, blue: 0.85).opacity(0.6))
			}
			Spacer()
		}
		.padding(.bottom, 16)
	}
	
	private func horizontalLayout(for width: CGFloat) -> some View {
		HStack(alignment: .top, spacing: width < 910 ? 12 : 20) {
			horizontalCategoriesView(for: width)
			ScrollView(showsIndicators: false) {
				horizontalListView(for: width)
			}
			.frame(maxWidth: 500)
			.mask(linearGradientMask)
			
			if let projectId = uiState.selectedProjectId, let project = projects.first(where: { $0.id.uuidString == projectId }) {
				horizontalDetailView(for: project, width: width)
					.frame(maxWidth: 400)
			}
		}
	}
	
	private func verticalLayout(for width: CGFloat) -> some View {
		VStack(spacing: 20) {
			verticalCategoriesView()
			
			ScrollView(.vertical, showsIndicators: false) {
				VStack(alignment: .leading, spacing: 20) {
					if uiState.selectedCategory == "All" || uiState.selectedCategory == "Unlocked" {
						verticalLayoutSection(
							title: "Unlocked",
							projects: unlockedProjects,
							isExpanded: $unlockedSectionExpanded,
							isLocked: false
						)
					}
					
					if uiState.selectedCategory == "All" || uiState.selectedCategory == "Locked" {
						verticalLayoutSection(
							title: "Locked",
							projects: lockedProjects,
							isExpanded: $lockedSectionExpanded,
							isLocked: true
						)
					}
					
					if uiState.selectedCategory == "All" || uiState.selectedCategory == "Completed" {
						verticalLayoutSection(
							title: "Completed",
							projects: completedProjects,
							isExpanded: $completedSectionExpanded,
							isLocked: false,
							isCompleted: true
						)
					}
				}
				.padding(.bottom, 40)
			}
		}
	}
	
	private func horizontalCategoriesView(for width: CGFloat) -> some View {
		VStack(alignment: .center, spacing: 0) {
			ForEach(["All", "Unlocked", "Locked", "Completed"], id: \.self) { category in
				Button(action: {
					withAnimation(.easeInOut(duration: 0.3)) {
						uiState.selectedCategory = category
					}
				}) {
					HStack(spacing: width < 910 ? 4 : 8) {
						Image(systemName: category == "All" ? "square.grid.2x2.fill" :
								category == "Unlocked" ? "bookmark.fill" :
								category == "Locked" ? "lock.fill" :
								"checkmark.seal.fill")
						.font(.system(size: width < 910 ? 28 : 40))
						.foregroundStyle(
							uiState.selectedCategory == category
							? AnyShapeStyle(activeGradient)
							: AnyShapeStyle(Color.gray)
						)
						.frame(width: width < 910 ? 40: 55)
						
						Rectangle()
							.frame(width: 2, height: width < 910 ? 65 : 85)
							.foregroundStyle(
								uiState.selectedCategory == category
								? AnyShapeStyle(activeGradient)
								: AnyShapeStyle(Color.clear)
							)
							.opacity(uiState.selectedCategory == category ? 0.4 : 0)
					}
				}
				.buttonStyle(.plain)
			}
		}
	}
	
	private func horizontalListView(for width: CGFloat) -> some View {
		VStack(spacing: 20) {
			if uiState.selectedCategory == "All" || uiState.selectedCategory == "Unlocked" {
				HorizontalProjectSection(
					title: "Unlocked",
					projects: unlockedProjects,
					icon: "circle",
					iconColor: .gray,
					isExpanded: $unlockedExpanded,
					selectedProjectId: $uiState.selectedProjectId,
					headerColor: .projectsUnlocked,
					width: width
				)
			}
			
			if uiState.selectedCategory == "All" || uiState.selectedCategory == "Locked" {
				HorizontalProjectSection(
					title: "Locked",
					projects: lockedProjects,
					icon: "lock.circle.fill",
					iconColor: .gray,
					isExpanded: $lockedExpanded,
					selectedProjectId: $uiState.selectedProjectId,
					headerColor: .projectsLocked,
					width: width
				)
			}
			
			if uiState.selectedCategory == "All" || uiState.selectedCategory == "Completed" {
				HorizontalProjectSection(
					title: "Completed",
					projects: completedProjects,
					icon: "checkmark.seal.fill",
					iconColor: .green,
					isExpanded: $completedExpanded,
					selectedProjectId: $uiState.selectedProjectId,
					headerColor: .projectsCompleted,
					width: width
				)
			}
		}
		.padding(.bottom, 100)
	}
	
	private func horizontalDetailView(for project: Project, width: CGFloat) -> some View {
		VStack(alignment: .leading, spacing: 9) {
			Text(project.projectName)
				.font(.system(size: width < 910 ? 32 : 48).weight(.bold))
				.foregroundColor(.white)
				.fixedSize(horizontal: false, vertical: true)
			
			HStack(spacing: 0) {
				Image(systemName: project.projectDifficulty == "Easy" ? "birthday.cake" : project.projectDifficulty == "Medium" ? "figure.run" : "figure.climbing")
				Text(project.projectDifficulty)
			}
			.font(width < 910 ? .title.bold() : .largeTitle.bold())
			.foregroundStyle(project.projectDifficulty == "Easy" ? .green : project.projectDifficulty == "Medium" ? .yellow : .red)
			.padding(.bottom, 9)
			
			Text(project.projectDescription)
				.font(width < 910 ? .title3 : .title2)
				.foregroundColor(.white)
				.multilineTextAlignment(.leading)
				.padding(.horizontal, 16)
				.fixedSize(horizontal: false, vertical: true)
			
			if project.levelPrerequisite > userData.highestCompletedLevel {
				let moduleName = modules[project.levelPrerequisite - 1].moduleName
				(Text("Complete ")
				 + Text(moduleName)
					.fontWeight(.bold)
					.underline()
				 + Text(" to unlock."))
				.padding(.vertical, width < 910 ? 18 : 24)
				.padding(.horizontal, 18)
				.frame(maxWidth: .infinity, alignment: .center)
				.font(width < 910 ? .title3 : .title2)
				.foregroundColor(.projectsButtonOff)
				.background(.projectsLocked)
				.clipShape(.rect(cornerRadius: 6))
				.padding(.top, 32)
				.padding(.horizontal, 16)
			}
			
			if project.levelPrerequisite <= userData.highestCompletedLevel {
				NavigationLink(destination: ProjectDetailView(project: project)) {
					HStack {
						Spacer()
						
						Text("Start")
							.padding(.vertical, 12)
							.padding(.horizontal, 64)
							.font(.title3.bold())
							.foregroundColor(.white)
							.background(Color("ButtonColor"))
							.clipShape(.rect(cornerRadius: 10))
						
						Spacer()
					}
				}
				.buttonStyle(.plain)
				.padding(.top, 32)
			}
		}
	}
	
	private var linearGradientMask: some View {
		LinearGradient(gradient: Gradient(stops: [
			.init(color: .black, location: 0),
			.init(color: .black, location: 0.8),
			.init(color: .clear, location: 0.97)
		]), startPoint: .top, endPoint: .bottom)
	}
	
	private func verticalCategoriesView() -> some View {
		HStack {
			ForEach(["All", "Unlocked", "Locked", "Completed"], id: \.self) { category in
				Button(action: {
					withAnimation { uiState.selectedCategory = category }
				}) {
					Text(category)
						.fontWeight(.semibold)
						.padding(.vertical, 8)
						.frame(maxWidth: .infinity)
						.background(uiState.selectedCategory == category ? Color.white : Color.clear)
						.foregroundColor(uiState.selectedCategory == category ? .black : .gray)
						.cornerRadius(8)
				}
				.buttonStyle(.plain)
			}
		}
		.padding(4)
		.background(Color.black.opacity(0.25))
		.cornerRadius(10)
	}
	
	@ViewBuilder
	private func verticalLayoutSection(title: String, projects: [Project], isExpanded: Binding<Bool>, isLocked: Bool, isCompleted: Bool = false) -> some View {
		if !projects.isEmpty {
			VStack(spacing: 10) {
				Button(action: { withAnimation { isExpanded.wrappedValue.toggle() }}) {
					HStack {
						Text(title)
							.font(.title2.bold())
							.foregroundStyle(.black)
						Spacer()
						Image(systemName: "chevron.right")
							.rotationEffect(.degrees(isExpanded.wrappedValue ? 90 : 0))
							.font(.title3)
							.foregroundStyle(.white.opacity(0.85))
					}
					.padding(.horizontal)
					.frame(height: 55)
					.background(LinearGradient(
						stops: [
							.init(color: colorForCategory(title), location: 0.38),
							.init(color: .gray.opacity(0), location: 1.0)
						],
						startPoint: .leading,
						endPoint: .trailing
					))
					.foregroundStyle(.white)
					.clipShape(.rect(cornerRadius: 8))
				}
				.buttonStyle(.plain)
				
				if isExpanded.wrappedValue {
					VStack(spacing: 10) {
						ForEach(projects) { project in
							VerticalProjectRow(
								project: project,
								isLocked: isLocked,
								isCompleted: isCompleted,
								selectedProjectId: $uiState.selectedProjectId,
								modules: modules,
								userData: userData,
								headerColor: colorForCategory(title)
							)
						}
					}
				}
			}
		}
	}
	
	private func colorForCategory(_ category: String) -> Color {
		switch category {
		case "Unlocked": return .projectsUnlocked
		case "Locked": return .projectsLocked
		case "Completed": return .projectsCompleted
		default: return .gray
		}
	}
}

struct HorizontalProjectSection: View {
	let title: String
	let projects: [Project]
	let icon: String
	let iconColor: Color
	@Binding var isExpanded: Bool
	@Binding var selectedProjectId: String?
	let headerColor: Color
	let width: CGFloat
	
	var body: some View {
		VStack(spacing: 10) {
			Button(action: { withAnimation(.easeInOut(duration: 0.2)) { isExpanded.toggle() } }) {
				HStack {
					Text(title)
						.font(width < 910 ? .title2.bold() : .title.bold())
						.foregroundStyle(.black)
					Spacer()
					Image(systemName: "chevron.right")
						.rotationEffect(.degrees(isExpanded ? 90 : 0))
						.font(width < 910 ? .title3 : .title2)
						.foregroundStyle(.white.opacity(0.85))
				}
				.padding(.horizontal)
				.frame(height: 55)
				.background(LinearGradient(
					stops: [
						.init(color: headerColor, location: 0.38),
						.init(color: .gray.opacity(0), location: 1.0)
					],
					startPoint: .leading,
					endPoint: .trailing
				))
				.foregroundStyle(.white)
				.clipShape(.rect(cornerRadius: 8))
			}
			.buttonStyle(.plain)
			
			VStack(spacing: 10) {
				if isExpanded {
					ForEach(projects) { project in
						HorizontalProjectRow(
							project: project,
							icon: icon,
							iconColor: iconColor,
							isSelected: selectedProjectId == project.id.uuidString,
							headerColor: headerColor,
							width: width
						)
						.onTapGesture {
							withAnimation(.easeIn(duration: 0.1)) {
								selectedProjectId = project.id.uuidString
							}
						}
					}
				}
			}
		}
	}
}


struct HorizontalProjectRow: View {
	let project: Project
	let icon: String
	let iconColor: Color
	let isSelected: Bool
	let headerColor: Color
	let width: CGFloat
	
	private var rowBackgroundColor: Color {
		isSelected ? Color("ProjectsButtonOn") : Color("ProjectsButtonOff")
	}
	
	var body: some View {
		HStack(spacing: 12) {
			Rectangle()
				.foregroundStyle(headerColor)
				.frame(width: 4, height: 54)
				.clipShape(.rect(cornerRadius: 6))
				.padding(.vertical, 6)
			
			ZStack(alignment: .center) {
				Image(systemName: icon)
					.font(width < 910 ? .title : .largeTitle)
					.foregroundStyle(iconColor)
					.background(rowBackgroundColor)
					.padding(.vertical, 2)
					.frame(width: 20)
				
				if isSelected && icon == "circle" {
					Circle()
						.fill(headerColor)
						.frame(width: 14, height: 14)
						.padding(.top, 1)
				}
			}
			
			Text(project.projectName)
				.foregroundStyle(.white)
				.font(width < 910 ? .title2 : .title)
			
			Spacer()
		}
		.padding(.leading, 6)
		.background(rowBackgroundColor)
		.clipShape(.rect(cornerRadius: 10))
	}
}

private struct VerticalProjectRow: View {
	let project: Project
	let isLocked: Bool
	let isCompleted: Bool
	@Binding var selectedProjectId: String?
	let modules: [Module]
	let userData: UserData
	let headerColor: Color
	
	var isExpanded: Bool {
		selectedProjectId == project.id.uuidString
	}
	
	private var icon: String {
		isLocked ? "lock.circle.fill" : (isCompleted ? "checkmark.seal.fill" : "circle")
	}
	
	private var iconColor: Color {
		isLocked ? .gray : (isCompleted ? .green : .gray)
	}
	
	private var rowBackgroundColor: Color {
		isExpanded ? Color("ProjectsButtonOn") : Color("ProjectsButtonOff")
	}
	
	var body: some View {
		HStack(alignment: .top, spacing: 12) {
			VStack {
				Rectangle()
					.foregroundStyle(headerColor)
					.frame(width: 4)
					.clipShape(.rect(cornerRadius: 6))
			}
			.padding(.vertical, 6)
			
			VStack(alignment: .leading, spacing: 0) {
				HStack {
					ZStack(alignment: .center) {
						Image(systemName: icon)
							.font(.title)
							.foregroundStyle(iconColor)
							.background(rowBackgroundColor)
							.padding(.vertical, 2)
							.frame(width: 20)
						
						if isExpanded && icon == "circle" {
							Circle()
								.fill(headerColor)
								.frame(width: 14, height: 14)
								.padding(.top, 1)
						}
					}
					
					Text(project.projectName)
						.fontWeight(.medium)
						.foregroundColor(.white)
					
					Spacer()
					
					Image(systemName: "chevron.right")
						.font(.body.weight(.semibold))
						.foregroundColor(.gray)
						.rotationEffect(.degrees(isExpanded ? 90 : 0))
				}
				.font(.headline)
				.padding(.vertical)
				.padding(.trailing)
				.contentShape(Rectangle())
				.onTapGesture {
					withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
						selectedProjectId = isExpanded ? nil : project.id.uuidString
					}
				}
				
				if isExpanded {
					VStack(alignment: .leading, spacing: 15) {
						DifficultyBadge(difficulty: project.projectDifficulty)
						
						Text(project.projectDescription)
							.font(.subheadline)
							.foregroundColor(.white.opacity(0.8))
							.lineSpacing(4)
							.fixedSize(horizontal: false, vertical: true)
						
						if isLocked {
							let moduleName = modules[project.levelPrerequisite - 1].moduleName
							(Text("Complete ")
							 + Text(moduleName)
								.fontWeight(.bold)
								.underline()
							 + Text(" to unlock."))
							.font(.subheadline)
							.foregroundColor(.white.opacity(0.7))
							.padding(.top, 8)
							
						} else {
							NavigationLink(destination: ProjectDetailView(project: project)) {
								Text(isCompleted ? "View Project" : "Start")
									.fontWeight(.bold)
									.foregroundColor(.white)
									.padding(.vertical, 10)
									.frame(maxWidth: .infinity)
									.background(isCompleted ? Color.green.opacity(0.8) : Color.blue)
									.cornerRadius(8)
							}
							.buttonStyle(.plain)
						}
					}
					.padding(.trailing)
					.padding(.bottom)
					.transition(.asymmetric(insertion: .opacity.combined(with: .move(edge: .top)), removal: .opacity))
				}
			}
		}
		.padding(.leading, 6)
		.background(rowBackgroundColor)
		.cornerRadius(10)
	}
}

private struct DifficultyBadge: View {
	let difficulty: String
	
	private var color: Color {
		switch difficulty {
		case "Easy": return .green
		case "Medium": return .yellow
		default: return .red
		}
	}
	
	var body: some View {
		Text(difficulty)
			.font(.caption.weight(.bold))
			.padding(.horizontal, 10)
			.padding(.vertical, 4)
			.background(color.opacity(0.8))
			.foregroundColor(.white)
			.cornerRadius(12)
	}
}
