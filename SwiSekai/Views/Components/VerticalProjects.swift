//
//  VerticalProjects.swift
//  SwiSekai
//
//  Created by Agustio Maitimu on 20/08/25.
//

import SwiftUI

struct VerticalProjects: View {
	@Binding var selectedProjectId: String?
	let projects: [Project]
	let userData: UserData
	let modules: [Module]
	@StateObject private var uiState = ProjectsUIState.shared
	
	@State private var unlockedSectionExpanded: Bool = true
	@State private var lockedSectionExpanded: Bool = true
	@State private var completedSectionExpanded: Bool = true
	
	private var completedProjects: [Project] {
		projects
			.filter { userData.completedProjects.contains($0.id) }
			.sorted { $0.projectDifficulty < $1.projectDifficulty }
	}
	
	private var unlockedProjects: [Project] {
		projects
			.filter { $0.levelPrerequisite <= userData.currentLevel && !userData.completedProjects.contains($0.id) }
			.sorted { $0.projectDifficulty < $1.projectDifficulty }
	}
	
	private var lockedProjects: [Project] {
		projects
			.filter { $0.levelPrerequisite > userData.currentLevel }
			.sorted { $0.projectDifficulty > $1.projectDifficulty }
	}
	
	var body: some View {
		VStack(spacing: 20) {
			categoryPicker()
			
			ScrollView(.vertical, showsIndicators: false) {
				VStack(alignment: .leading, spacing: 20) {
					if uiState.selectedCategory == "All" || uiState.selectedCategory == "Unlocked" {
						CategoryDropdown(
							title: "Unlocked",
							projects: unlockedProjects,
							isExpanded: $unlockedSectionExpanded,
							isLocked: false,
							headerColor: .projectsUnlocked,
							modules: modules,
							userData: userData
						)
					}
					
					if uiState.selectedCategory == "All" || uiState.selectedCategory == "Locked" {
						CategoryDropdown(
							title: "Locked",
							projects: lockedProjects,
							isExpanded: $lockedSectionExpanded,
							isLocked: true,
							headerColor: .projectsLocked,
							modules: modules,
							userData: userData
						)
					}
					
					if uiState.selectedCategory == "All" || uiState.selectedCategory == "Completed" {
						CategoryDropdown(
							title: "Completed",
							projects: completedProjects,
							isExpanded: $completedSectionExpanded,
							isLocked: false,
							isCompleted: true,
							headerColor: .projectsCompleted,
							modules: modules,
							userData: userData
						)
					}
				}
				.padding(.bottom, 40)
			}
		}
	}
	
	private func categoryPicker() -> some View {
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
}

private struct CategoryDropdown: View {
	let title: String
	let projects: [Project]
	@Binding var isExpanded: Bool
	let isLocked: Bool
	var isCompleted: Bool = false
	let headerColor: Color
	let modules: [Module]
	let userData: UserData
	@StateObject private var uiState = ProjectsUIState.shared
	
	var body: some View {
		if !projects.isEmpty {
			VStack(spacing: 10) {
				Button(action: { withAnimation { isExpanded.toggle() }}) {
					HStack {
						Text(title)
							.font(.title2.bold())
							.foregroundStyle(.black)
						Spacer()
						Image(systemName: "chevron.right")
							.rotationEffect(.degrees(isExpanded ? 90 : 0))
							.font(.title3)
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
				
				if isExpanded {
					VStack(spacing: 10) {
						ForEach(projects) { project in
							ProjectRow(
								project: project,
								isLocked: isLocked,
								isCompleted: isCompleted,
								selectedProjectId: $uiState.selectedProjectId,
								modules: modules,
								userData: userData,
								headerColor: headerColor
							)
						}
					}
				}
			}
		}
	}
}

private struct ProjectRow: View {
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
