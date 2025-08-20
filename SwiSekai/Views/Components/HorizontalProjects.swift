//
//  HorizontalProjects.swift
//  SwiSekai
//
//  Created by Agustio Maitimu on 20/08/25.
//

import SwiftUI

struct HorizontalProjects: View {
	@Binding var selectedProjectId: String?
	let projects: [Project]
	let userData: UserData
	let modules: [Module]
	@StateObject private var uiState = ProjectsUIState.shared
	
	@State private var unlockedExpanded = true
	@State private var lockedExpanded = true
	@State private var completedExpanded = true
	
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
	
	let activeCategoryGradient = LinearGradient(
		stops: [
			.init(color: Color(red: 0.99, green: 0.25, blue: 0), location: 0.00),
			.init(color: Color(red: 1, green: 0.49, blue: 0.25), location: 1.00),
		],
		startPoint: .top,
		endPoint: .bottom
	)
	
	var body: some View {
		GeometryReader { geometry in
			HStack(alignment: .top, spacing: geometry.size.width < 910 ? 12 : 20) {
				categoryPicker(width: geometry.size.width)
				
				ScrollView(showsIndicators: false) {
					VStack(spacing: 20) {
						if uiState.selectedCategory == "All" || uiState.selectedCategory == "Unlocked" {
							CategoryDropdown(
								title: "Unlocked",
								projects: unlockedProjects,
								icon: "circle",
								iconColor: .gray,
								isExpanded: $unlockedExpanded,
								selectedProjectId: $uiState.selectedProjectId,
								headerColor: .projectsUnlocked,
								width: geometry.size.width
							)
						}
						
						if uiState.selectedCategory == "All" || uiState.selectedCategory == "Locked" {
							CategoryDropdown(
								title: "Locked",
								projects: lockedProjects,
								icon: "lock.circle.fill",
								iconColor: .gray,
								isExpanded: $lockedExpanded,
								selectedProjectId: $uiState.selectedProjectId,
								headerColor: .projectsLocked,
								width: geometry.size.width
							)
						}
						
						if uiState.selectedCategory == "All" || uiState.selectedCategory == "Completed" {
							CategoryDropdown(
								title: "Completed",
								projects: completedProjects,
								icon: "checkmark.seal.fill",
								iconColor: .green,
								isExpanded: $completedExpanded,
								selectedProjectId: $uiState.selectedProjectId,
								headerColor: .projectsCompleted,
								width: geometry.size.width
							)
						}
					}
					.padding(.bottom, 100)
				}
				.frame(maxWidth: 500)
				.mask(linearGradientMask)
				
				if let projectId = uiState.selectedProjectId, let project = projects.first(where: { $0.id.uuidString == projectId }) {
					detailView(project: project, width: geometry.size.width)
						.frame(maxWidth: 400)
				}
			}
		}
	}
	
	private func categoryPicker(width: CGFloat) -> some View {
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
							? AnyShapeStyle(activeCategoryGradient)
							: AnyShapeStyle(Color.gray)
						)
						.frame(width: width < 910 ? 40: 55)
						
						Rectangle()
							.frame(width: 2, height: width < 910 ? 65 : 85)
							.foregroundStyle(
								uiState.selectedCategory == category
								? AnyShapeStyle(activeCategoryGradient)
								: AnyShapeStyle(Color.clear)
							)
							.opacity(uiState.selectedCategory == category ? 0.4 : 0)
					}
				}
				.buttonStyle(.plain)
			}
		}
	}
	
	private func detailView(project: Project, width: CGFloat) -> some View {
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
}

private struct CategoryDropdown: View {
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
						ProjectRow(
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

private struct ProjectRow: View {
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
