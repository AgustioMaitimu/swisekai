// SwiSekai/SwiSekaiApp.swift

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
			test_balls()
				.background(.mainBackground)
				.onAppear() {
					let context = modelContainer.mainContext
					let userData = UserData.shared(in: context)
					userData.registerOpen()
				}
		}
		.modelContainer(modelContainer)
	}
}
