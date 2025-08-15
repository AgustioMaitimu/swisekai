// SwiSekaiApp.swift

import SwiftUI
import SwiftData

@main
struct SwiSekaiApp: App {
	let modelContainer: ModelContainer
	
	init() {
		do {
			modelContainer = try ModelContainer(for: UserData.self)
		} catch {
			fatalError("Could not initialize ModelContainer: \(error)")
		}
	}
	
	var body: some Scene {
		WindowGroup {
//			ProjectsView()
//				.onAppear(perform: checkLogin)
			ContentView()
				.onAppear(perform: checkLogin)
		}
		.modelContainer(modelContainer)
	}
	
	func checkLogin() {
		let context = modelContainer.mainContext
		let userData = UserData.shared(in: context)
		
		if !Calendar.current.isDateInToday(userData.lastLogin) {
			userData.totalLogin += 1
			userData.lastLogin = Date()
			
			print("Login counted for today! Total login days: \(userData.totalLogin)")
		} else {
			print("Already logged in today. Total login days: \(userData.totalLogin)")
		}
	}
}
