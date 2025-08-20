//
//  ProjectsView.swift
//  SwiSekai
//
//  Created by Agustio Maitimu on 12/08/25.
//

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
	
	var body: some View {
		GeometryReader { geometry in
			VStack(spacing: 0) {
				headerView(for: geometry.size.width)
				
				if geometry.size.width < 700 {
					VerticalProjects(
						selectedProjectId: $uiState.selectedProjectId,
						projects: projects,
						userData: userData,
						modules: modules
					)
				} else {
					HorizontalProjects(
						selectedProjectId: $uiState.selectedProjectId,
						projects: projects,
						userData: userData,
						modules: modules
					)
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
}
