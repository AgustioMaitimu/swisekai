//
//  UserData.swift
//  SwiSekai
//
//  Created by Agustio Maitimu on 12/08/25.
//

import Foundation
import SwiftData

@Model
final class UserData {
	@Attribute(.unique) var id: UUID
	var highestCompletedLevel: Int
	var unlockedProjects: [UUID]
	var completedProjects: [UUID]
	
	init() {
		self.id = UUID()
		self.highestCompletedLevel = 1
		self.unlockedProjects = []
		self.completedProjects = []
		self.unlockInitialProjects()
	}
	
	static func shared(in context: ModelContext) -> UserData {
		if let existingUser = try? context.fetch(FetchDescriptor<UserData>()).first {
			return existingUser
		} else {
			let newUser = UserData()
			context.insert(newUser)
			return newUser
		}
	}
	
	func completeLevel() {
		self.highestCompletedLevel += 1
		unlockProjects(for: self.highestCompletedLevel)
	}
	
	func completeProject(id: UUID) {
		if !self.completedProjects.contains(id) {
			self.completedProjects.append(id)
		}
	}
	
	func unlockProjects(for level: Int) {
		let allProjects = DataManager.shared.projectCollection.projects
		
		let newlyUnlocked = allProjects.filter { $0.level_prerequisite == level }
			.map { $0.id }
		
		for projectId in newlyUnlocked {
			if !self.unlockedProjects.contains(projectId) {
				self.unlockedProjects.append(projectId)
			}
		}
	}
	
	private func unlockInitialProjects() {
		let allProjects = DataManager.shared.projectCollection.projects
		
		let projectsToUnlock = allProjects.filter { $0.level_prerequisite <= self.highestCompletedLevel }
			.map { $0.id }
		
		for projectId in projectsToUnlock {
			if !self.unlockedProjects.contains(projectId) {
				self.unlockedProjects.append(projectId)
			}
		}
	}
}
