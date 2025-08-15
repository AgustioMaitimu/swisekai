// SwiSekai/Views/ProjectsView.swift

import SwiftUI

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
	var projects = DataManager.shared.projectCollection.projects
	@State var projectId = "E621E1F8-C36C-495A-93FC-0C247A3E6E5F"
	
	@State private var selectedCategory: ProjectCategory = .all
	
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
							// Using .easeInOut for that smooth fade effect
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
				
				VStack(alignment: .leading) {
					ForEach(projects, id: \.id) { project in
						Button(project.projectName) {
							projectId = project.id.uuidString
						}
						.background(projectId == project.id.uuidString ? .red : .brown)
					}
				}
				
				if let project = projects.first(where: { $0.id.uuidString == projectId }) {
					VStack(alignment: .leading, spacing: 8) {
						Text(project.projectName)
							.font(.title.bold())
						Text(project.projectDifficulty)
							.font(.headline.bold())
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
