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
		self.highestCompletedLevel = 5
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
		completeProject(id: UUID(uuidString: "0C8D23A7-522A-44C3-A33B-32825B3E144C")!)
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
