// SwiSekai/Models/UserData.swift

import Foundation
import SwiftData

@Model
final class UserData {
	@Attribute(.unique) var id: UUID
	var highestCompletedLevel: Int
	var completedProjects: [UUID]
	var loginDayKeys: [String]
	
	init() {
		self.id = UUID()
		self.highestCompletedLevel = 0
		self.completedProjects = []
		self.loginDayKeys = []
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
	}
	
	func completeProject(id: UUID) {
		if !self.completedProjects.contains(id) {
			self.completedProjects.append(id)
		}
	}
	
	private func dayKey(_ date: Date = Date()) -> String {
		let calendar = Calendar.autoupdatingCurrent
		let components = calendar.dateComponents([.year, .month, .day], from: date)
		guard let y = components.year, let m = components.month, let d = components.day else { return "0000-00-00" }
		let mm = m < 10 ? "0\(m)" : "\(m)"
		let dd = d < 10 ? "0\(d)" : "\(d)"
		return "\(y)-\(mm)-\(dd)"
	}
	
	func registerOpen() {
		let key = dayKey()
		if !loginDayKeys.contains(key) {
			loginDayKeys.append(key)
		}
	}
	
	var last7DayActivity: [String] {
		let calendar = Calendar.autoupdatingCurrent
		let today = calendar.startOfDay(for: Date())
		return (0..<7).reversed().map { offset in
			let day = calendar.date(byAdding: .day, value: -offset, to: today)!
			let key = dayKey(day)
			return loginDayKeys.contains(key) ? "active" : "inactive"
		}
	}
	
	var totalActiveDays: Int {
		loginDayKeys.count
	}
}
