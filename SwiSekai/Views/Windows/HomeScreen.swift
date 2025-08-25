//
//  HomeScreen.swift
//  SwiSekai
//
//  Created by Adrian Yusufa Rachman on 19/08/25.
//

import SwiftUI
import SwiftData

// NOTE: Assuming NavigationItem is an enum defined elsewhere in the project, like this:
// enum NavigationItem {
//     case home, projects, resources, profile
// }

struct HomeScreen: View {
	
	@Environment(\.modelContext) private var modelContext
	@Query private var userDataItems: [UserData]
	@Binding var selection: NavigationItem
	private var userData: UserData { userDataItems.first ?? UserData.shared(in: modelContext) }
	private var modules = DataManager.shared.moduleCollection.modules
	private var chapters = DataManager.shared.chapterCollection.chapters
	private var projects = DataManager.shared.projectCollection.projects
	
	// MARK: - Current Progress Info
	
	/// A private computed property to find the current chapter based on the user's level.
	private var currentChapter: Chapter? {
		chapters.first { chapter in
			chapter.modules.contains { module in
				module.moduleNumber == userData.currentLevel
			}
		}
	}
	
	/// A computed property for the current chapter's number.
	private var currentChapterNumber: Int {
		// Find the index of the current chapter. Add 1 for human-readable format.
		if let chapter = currentChapter, let index = chapters.firstIndex(where: { $0.chapterName == chapter.chapterName }) {
			return index + 1
		}
		return 1 // Default to 1 if not found
	}
	
	/// A computed property for the current chapter's title.
	private var currentChapterTitle: String {
		// Return the name from the found chapter, or a default string.
		return currentChapter?.chapterName ?? "The Basics"
	}
	
	/// A computed property for the current module's (level's) title.
	private var currentLevelTitle: String {
		// Find the module that matches the user's current level.
		if let module = modules.first(where: { $0.moduleNumber == userData.currentLevel }) {
			return module.moduleName
		}
		return "Start your journey!" // Default title
	}
	
	// MARK: - Initializer
	// This explicit initializer is now 'internal' by default, making it accessible
	// from other files like SideBarView and TabBarView.
	init(selection: Binding<NavigationItem>) {
		self._selection = selection
	}
	
	private var completedModules: Int {
		userData.currentLevel
	}
	
	private var totalModules: Int {
		modules.count
	}
	
	// A computed property that returns only the last 7 days for display.
	private var recentActivity: [String] {
		userData.last7DayActivity
	}
	
	// This still calculates the total from the *entire* activity list.
	private var activeDays: Int {
		userData.totalActiveDays
	}
	
	// --- Computed Properties for Progress ---
	private var progress: Double {
		guard totalModules > 0 else {
			return 0.0 // Return 0 if there are no modules to complete.
		}
		return Double(completedModules) / Double(totalModules)
	}
	
	private var progressSubtitle: String {
		return "You have completed \(completedModules) out of \(totalModules) modules!"
	}
	
	private var progressPercentageText: String {
		return "\(Int(progress * 100))%"
	}
	
	// Define columns for the responsive grid
	private let columns = [GridItem(.adaptive(minimum: 350))]
	
	var body: some View {
		NavigationStack{
			// 1. Use a ZStack to manage the background and content layers
			VStack {
				// 2. Set a background that fills the entire screen, including safe areas
				//         Color.mainBackground // Make sure "mainBackground" is in your asset catalog
				//             .ignoresSafeArea()
				
				// 3. Your original ScrollView now acts as the main content block
				ScrollView(showsIndicators: false) {
					VStack {
						// --- All your original content goes inside this VStack ---
						
						Text("Home")
							.font(.largeTitle)
							.fontWeight(.bold)
							.foregroundColor(.white)
							.frame(maxWidth: .infinity, alignment: .leading)
							.padding(.bottom, 5)
						
						// Title 2/Emphasized
						Text("Apply your Swift skills by building real-world application")
							.font(
								Font.custom("Inter", size: 17)
									.weight(.bold)
							)
							.foregroundColor(Color(red: 0.85, green: 0.85, blue: 0.85).opacity(0.6))
							.frame(maxWidth: .infinity, alignment: .leading)
							.padding(.bottom, 50)
						
						Text("For you")
							.font(.title2)
							.fontWeight(.bold)
							.foregroundColor(.white)
						
							.frame(maxWidth: .infinity, alignment: .leading)
						
						
						// --- First responsive section ---
						ResponsiveStack {
							cardThingy(
								selection: $selection,
								chapterNumber: currentChapterNumber,
								chapterTitle: currentChapterTitle,
								levelTitle: currentLevelTitle
							)
							projectsView(selection: $selection, projects: projects, userData: userData)
						}
						.padding(.bottom, 53)
						
						Text("Progress")
							.font(.title2)
							.fontWeight(.bold)
							.foregroundColor(.white)
						
							.frame(maxWidth: .infinity, alignment: .leading)
						
						
						// --- Second responsive section ---
						ResponsiveStack {
							progressCard()
							activeLearningCard()
						}
						.padding(.bottom, 110)
						
						Text("Resources")
							.font(.title2)
							.fontWeight(.bold)
							.foregroundColor(.white)
						
							.frame(maxWidth: .infinity, alignment: .leading)
						
						
						let rows = [
							GridItem()
						]
						
						ScrollView(.horizontal, showsIndicators: false) {
							LazyHGrid(rows: rows, spacing: 50) {
								resourceCard()
								resourceCard()
								resourceCard()
								resourceCard()
								
							}
							.padding()
						}
					}
				}
				
				.frame(maxWidth: 1200)
				.padding(.vertical, 20)
				.padding(.horizontal, 20)
			}
		}
	}
	
	func progressCard() -> some View {
		VStack(alignment: .leading){
			Text("Total Progress")
				.font(.title3.weight(.bold))
				.foregroundColor(.white)
			
			Text(progressSubtitle)
				.font(.title3)
				.foregroundColor(.white.opacity(0.8))
				.padding(.top, 1)
				.fixedSize(horizontal: false, vertical: true)
			
			Spacer()
			
			HStack{
				GeometryReader { geo in
					ZStack(alignment: .leading) {
						Rectangle()
							.fill(.white)
							.frame(height: 16)
							.cornerRadius(10)
						Rectangle()
							.fill(
								LinearGradient(
									stops: [
										Gradient.Stop(color: Color(red: 0.99, green: 0.25, blue: 0), location: 0.00),
										Gradient.Stop(color: Color(red: 1, green: 0.49, blue: 0.25), location: 1.00),
									],
									startPoint: .leading,
									endPoint: .trailing
								)
							)
							.frame(width: geo.size.width * CGFloat(progress), height: 16)
							.cornerRadius(10)
					}
				}
				
				Text(progressPercentageText)
					.font(.title2.weight(.bold))
					.multilineTextAlignment(.trailing)
					.foregroundColor(.white)
			}
			.frame(maxHeight: 16)
		}
		.padding()
		.frame(minHeight: 132)
		.background(Color(red: 0.19, green: 0.2, blue: 0.21))
		.cornerRadius(12)
	}
	
	func activeLearningCard() -> some View {
		HStack {
			VStack(alignment: .leading){
				Text("Active Learning")
					.font(.title3.weight(.bold))
					.foregroundColor(.white)
					.padding(.bottom, 20)
				
				HStack{
					ForEach(recentActivity.indices, id: \.self) { index in
						Rectangle()
							.fill(recentActivity[index] == "active" ? // Changed from .active to "active"
								  LinearGradient(
									stops: [
										Gradient.Stop(color: Color(red: 0.99, green: 0.25, blue: 0), location: 0.00),
										Gradient.Stop(color: Color(red: 1, green: 0.49, blue: 0.25), location: 1.00),
									],
									startPoint: UnitPoint(x: 0.5, y: 0),
									endPoint: UnitPoint(x: 0.5, y: 1)
								  ) : LinearGradient(
									stops: [Gradient.Stop(color: .white, location: 0.00)],
									startPoint: .top,
									endPoint: .bottom
								  )
							)
							.aspectRatio(1, contentMode: .fit)
							.cornerRadius(4)
					}
				}
			}
			
			VStack {
				Text("\(activeDays) Days")
					.font(.system(size: 38, weight: .bold,))
					.multilineTextAlignment(.trailing)
					.foregroundColor(.white)
					.padding(.horizontal, 40)
			}
		}
		.padding()
		.frame(minHeight: 132)
		.background(Color(red: 0.19, green: 0.2, blue: 0.21))
		.cornerRadius(12)
	}
	
	func resourceCard() -> some View {
		VStack {
			Rectangle()
				.fill(.gray)
				.frame(width: 392, height: 152)
				.cornerRadius(8)
			
			Text("WWDC25")
				.font(.title2.weight(.bold))
				.padding(.top,10)
				.padding(.bottom ,4)
				.foregroundColor(.white)
				.frame(maxWidth:.infinity, alignment: .leading)
			
			Text("Access 100+ new videos with sessions,transcripts, docs, and sample code all in one place.")
				.font(.body)
				.frame(maxWidth:.infinity, alignment: .leading)
				.foregroundColor(.gray)
				.padding(.bottom,4)
			
			Spacer()
			
			Button(action: {}) {
				HStack{
					Spacer()
					Image(systemName: "arrow.up.forward.app.fill")
					Text("OPEN")
					Spacer()
				}
				.font(.headline.weight(.medium))
				.foregroundColor(.white)
				.padding()
				.frame(height: 42)
				.background(.blue)
				.cornerRadius(8)
			}
			.buttonStyle(.plain)
		}
		.padding()
		.background(.black.opacity(0.3))
		.cornerRadius(12)
		.frame(width: 392, height: 336)
	}
}

private func cardThingy(
	selection: Binding<NavigationItem>,
	chapterNumber: Int,
	chapterTitle: String,
	levelTitle: String
) -> some View {
	// card thingy
	VStack(alignment: .leading) {
		
		HStack{
			VStack(alignment: .leading){
				Text("Chapter \(chapterNumber)")
					.font(
						Font.custom("SF Pro", size: 20)
							.weight(.bold)
					)
					.foregroundColor(.white)
					.frame(maxWidth: .infinity, alignment: .leading)
				
				Text(chapterTitle.dropFirst(11))
					.font(
						Font.custom("SF Pro", size: 48)
							.weight(.bold)
					)
					.foregroundColor(.white)
					.frame(maxWidth: .infinity, alignment: .leading)
					.fixedSize(horizontal: false, vertical: true)
				
				Text(levelTitle)
					.font(
						Font.custom("SF Pro", size: 32)
							.weight(.medium)
					)
					.foregroundColor(.white)
					.frame(maxWidth: .infinity, alignment: .leading)
					.fixedSize(horizontal: false, vertical: true)
			}
			Image("logoswift")
				.resizable()
				.frame(width: 148, height: 148)
		}.padding(.bottom, 40)
		
		HStack{
			Button {
				selection.wrappedValue = .learn
			} label: {
				Text("Continue")
					.font(
						Font.custom("SF Pro", size: 20)
							.weight(.medium)
					)
					.multilineTextAlignment(.center)
					.foregroundColor(.white)
					.frame(width: 150, height: 54)
					.background(Color.blue)
					.cornerRadius(40)
					.frame(maxWidth: .infinity, alignment: .trailing)
			}
			.buttonStyle(.plain)
		}
		
	}
	.padding(30)
	.frame(minWidth: 800, maxWidth: .infinity, maxHeight: .infinity)
	.background(
		LinearGradient(
			stops: [
				Gradient.Stop(color: Color(red: 0.98, green: 0.63, blue: 0.25), location: 0.00),
				Gradient.Stop(color: Color(red: 0.94, green: 0.27, blue: 0.2), location: 1.00),
			],
			startPoint: UnitPoint(x: 0.5, y: 0),
			endPoint: UnitPoint(x: 0.5, y: 1)
		)
	)
	.cornerRadius(20)
	
}


private func projectsView(selection: Binding<NavigationItem>, projects: [Project], userData: UserData) -> some View {
	let unlockedProjects = projects.filter { $0.levelPrerequisite <= userData.currentLevel && !userData.completedProjects.contains($0.id) }
	let lockedProjects = projects.filter { $0.levelPrerequisite > userData.currentLevel }
	
	let projectsToShow = Array(unlockedProjects.prefix(3))
	let remainingSlots = 3 - projectsToShow.count
	let lockedProjectsToShow = Array(lockedProjects.prefix(remainingSlots))
	
	let finalProjects = projectsToShow + lockedProjectsToShow
	
	return VStack {
		Text("Projects")
			.font(
				Font.custom("SF Pro", size: 20)
					.weight(.bold)
			)
			.foregroundColor(.white)
			.frame(maxWidth: .infinity, alignment: .leading)
		
			.padding(.top, 25)
			.padding(.bottom, 15)
		
		
		VStack(spacing: 10){
			
			ForEach(finalProjects) { project in
				let isLocked = project.levelPrerequisite > userData.currentLevel
				NavigationLink {
					ProjectDetailView(project: project)
				} label: {
					HStack{
						Text(project.projectName)
							.font(
								Font.custom("SF Pro", size: 20)
									.weight(.medium))
							.foregroundStyle(.black)
						Spacer()
						
						Image(systemName: isLocked ? "lock.fill" : "chevron.right")
							.foregroundColor(.black)
							.padding(.trailing, 10)
					}
					.padding()
					.frame(minWidth: 314, maxWidth: .infinity, minHeight: 42, maxHeight: 42, alignment: .leading)
					.background(Color(red: 0.91, green: 0.91, blue: 0.91))
					.cornerRadius(100)
				}
				.buttonStyle(.plain)
				.disabled(isLocked)
			}
		}
		
		.padding(.bottom, 20)
		
		HStack(){
			Text("25%")
				.font(Font.custom("SF Pro", size: 16))
				.foregroundColor(.white)
				.frame(maxWidth:.infinity, alignment: .leading)
				.padding(.leading, 10)
			
			Spacer()
			
			Button {
				// By using the binding, we can change the state of the parent view.
				selection.wrappedValue = .projects
			} label: {
				Text("All projects")
					.font(
						Font.custom("SF Pro", size: 20)
							.weight(.medium)
					)
					.foregroundColor(.white)
					.frame(width: 170, height: 54)
					.background(Color(red: 0.04, green: 0.52, blue: 1))
					.cornerRadius(100)
					.padding(.bottom, 22)
			}
			.buttonStyle(.plain)
		}
	}
	.frame(maxWidth: .infinity, maxHeight: 370)
	.padding(.horizontal, 30)
	.background(Color(red: 0.19, green: 0.2, blue: 0.21))
	.cornerRadius(20)
}


// MARK: Responsive container
@ViewBuilder
private func ResponsiveStack<Content: View>(
	@ViewBuilder content: () -> Content
) -> some View {
	ViewThatFits(in: .horizontal) {
		HStack(alignment: .top, spacing: 20) { content() }
		VStack(alignment: .leading, spacing: 20) { content() }
	}
}


#Preview {
	// A dummy enum to allow the preview to compile.
	// Ensure this matches the actual enum used in the project.
	enum NavigationItem {
		case home, projects
	}
	
	// The HomeScreen requires a binding and a model container for its preview.
	// We provide a constant binding and an in-memory container.
	return HomeScreen(selection: .constant(.home))
		.modelContainer(for: UserData.self, inMemory: true)
}
