// SwiSekai/Models/UserData.swift

import Foundation
import SwiftData

@Model
final class UserData {
	@Attribute(.unique) var id: UUID
	var highestCompletedLevel: Int
	var completedProjects: [UUID]
	var lastLogin: Date
	var totalLogin: Int
	
	init() {
		self.id = UUID()
		self.highestCompletedLevel = 3
		self.completedProjects = []
		self.lastLogin = .distantPast
		self.totalLogin = 0
		self.addMockData()
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
	
	private func addMockData() {
		completeProject(id: UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F")!)
		completeProject(id: UUID(uuidString: "C9B8A7D6-E5F4-A3B2-C1D0-E9F8A7B6C5D4")!)
	}
	
	func completeLevel() {
		self.highestCompletedLevel += 1
	}
	
	func completeProject(id: UUID) {
		if !self.completedProjects.contains(id) {
			self.completedProjects.append(id)
		}
	}
}
