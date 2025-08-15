// SwiSekai/Views/ProjectsView.swift

import SwiftUI
import SwiftData

enum ProjectCategory: CaseIterable {
	case all, bookmarked, locked, completed
	
	var imageName: String {
		switch self {
		case .all: return "square.grid.2x2.fill"
		case .bookmarked: return "bookmark.fill"
		case .locked: return "lock.fill"
		case .completed: return "checkmark.seal.fill"
		}
	}
}

struct ProjectsView: View {
	@Environment(\.modelContext) private var modelContext
	@Query private var userDataItems: [UserData]
	private var userData: UserData { userDataItems.first ?? UserData.shared(in: modelContext) }
	
	var projects = DataManager.shared.projectCollection.projects
	@State var projectId = "E621E1F8-C36C-495A-93FC-0C247A3E6E5F"
	@State private var selectedCategory: ProjectCategory = .all
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
		VStack {
			HStack {
				Spacer()
				
				VStack(alignment: .leading, spacing: 10) {
					Text("Projects")
						.font(.largeTitle.bold())
					Text("Apply your Swift skills to real-world projects!")
						.font(
							Font.custom("Inter", size: 17)
								.weight(.bold)
						)
						.foregroundColor(Color(red: 0.85, green: 0.85, blue: 0.85).opacity(0.6))
				}
				
				Spacer()
				Spacer()
				Spacer()
			}
			.padding(.top, 40)
			
			HStack(alignment: .top) {
				VStack(alignment: .center, spacing: 0) {
					ForEach(ProjectCategory.allCases, id: \.self) { category in
						Button(action: {
							withAnimation(.easeInOut(duration: 0.3)) {
								self.selectedCategory = category
							}
						}) {
							HStack {
								Image(systemName: category.imageName)
									.font(.system(size: 40))
									.foregroundStyle(
										selectedCategory == category
										? AnyShapeStyle(activeGradient)
										: AnyShapeStyle(Color.gray)
									)
									.frame(width: 55)
								
								Rectangle()
									.frame(width: 2, height: 85)
									.foregroundStyle(
										selectedCategory == category
										? AnyShapeStyle(activeGradient)
										: AnyShapeStyle(Color.gray.opacity(0))
									)
							}
						}
						.buttonStyle(.plain)
					}
				}
				ScrollView {
					VStack(spacing: 15) {
						ProjectSection(
							title: "Unlocked",
							projects: unlockedProjects,
							icon: "circle",
							iconColor: .gray,
							isExpanded: $unlockedExpanded,
							selectedProjectId: $projectId,
							headerColor: .projectsUnlocked
						)
						
						ProjectSection(
							title: "Locked",
							projects: lockedProjects,
							icon: "lock.fill",
							iconColor: .gray,
							isExpanded: $lockedExpanded,
							selectedProjectId: $projectId,
							headerColor: .projectsLocked
						)
						
						ProjectSection(
							title: "Completed",
							projects: completedProjects,
							icon: "checkmark.circle.fill",
							iconColor: .green,
							isExpanded: $completedExpanded,
							selectedProjectId: $projectId,
							headerColor: .projectsCompleted
						)
					}
				}
				.frame(width: 300)
				
				if let project = projects.first(where: { $0.id.uuidString == projectId }) {
					VStack(alignment: .leading, spacing: 8) {
						Text(project.projectName)
							.font(.title.bold())
						HStack(spacing: 0) {
							Image(systemName: project.projectDifficulty == "Easy" ? "birthday.cake" : project.projectDifficulty == "Medium" ? "figure.run" : "figure.climbing")
								.font(.headline.bold())
								.foregroundStyle(project.projectDifficulty == "Easy" ? .green : project.projectDifficulty == "Medium" ? .yellow : .red)
							Text(project.projectDifficulty)
								.font(.headline.bold())
								.foregroundStyle(project.projectDifficulty == "Easy" ? .green : project.projectDifficulty == "Medium" ? .yellow : .red)
						}
						Text(project.projectDescription)
							.multilineTextAlignment(.leading)
					}
					.frame(width: 250, alignment: .leading)
				}
			}
			.padding(.horizontal, 40)
			
			Spacer()
		}
	}
}


struct ProjectSection: View {
	let title: String
	let projects: [Project]
	let icon: String
	let iconColor: Color
	@Binding var isExpanded: Bool
	@Binding var selectedProjectId: String
	let headerColor: Color
	var isLocked: Bool = false
	
	var body: some View {
		VStack(spacing: 5) {
			Button(action: { withAnimation(.easeInOut(duration: 0.2)) { isExpanded.toggle() } }) {
				HStack {
					Text(title)
						.font(.title3)
						.fontWeight(.bold)
						.foregroundStyle(.black)
					Spacer()
					Image(systemName: "chevron.down")
						.rotationEffect(.degrees(isExpanded ? 0 : -90))
						.font(.title2)
						.foregroundStyle(.white.opacity(0.85))
				}
				.padding(.horizontal)
				.frame(height: 38)
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
			
			if isExpanded {
				ForEach(projects) { project in
					ProjectRow(
						project: project,
						icon: icon,
						iconColor: iconColor,
						isSelected: selectedProjectId == project.id.uuidString,
						isLocked: isLocked
					)
					.onTapGesture {
						if !isLocked {
							selectedProjectId = project.id.uuidString
						}
					}
				}
			}
		}
	}
}


struct ProjectRow: View {
	let project: Project
	let icon: String
	let iconColor: Color
	let isSelected: Bool
	let isLocked: Bool
	
	private var rowBackgroundColor: Color {
		isSelected ? Color("ProjectsButtonOn") : Color("ProjectsButtonOff")
	}
	
	var body: some View {
		HStack(spacing: 12) {
			Image(systemName: icon)
				.font(.callout.weight(.medium))
				.foregroundStyle(iconColor)
				.background(rowBackgroundColor)
				.padding(.vertical, 2)
				.frame(width: 20)
			
			Text(project.projectName)
				.foregroundStyle(.white)
			
			Spacer()
		}
		.padding(.leading)
		.frame(height: 40)
		.background(rowBackgroundColor)
		.clipShape(.rect(cornerRadius: 6))
		.opacity(isLocked ? 0.6 : 1.0)
	}
}
