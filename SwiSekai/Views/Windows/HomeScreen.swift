//
//  HomeScreen.swift
//  SwiSekai
//
//  Created by Adrian Yusufa Rachman on 19/08/25.
//

import SwiftUI
import SwiftData

// MARK: - Custom Environment for Layout Direction
private struct ContainerLayoutKey: EnvironmentKey {
    static let defaultValue: Axis = .horizontal
}

extension EnvironmentValues {
    var containerLayout: Axis {
        get { self[ContainerLayoutKey.self] }
        set { self[ContainerLayoutKey.self] = newValue }
    }
}



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
    
    
    
    init(selection: Binding<NavigationItem>) {
        self._selection = selection
    }
    
    // Define columns for the responsive grid
    private let columns = [GridItem(.adaptive(minimum: 350))]
    
    var body: some View {
        GeometryReader { geo in
            NavigationStack{
                HStack {
                    Spacer()
                    
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .center) {
                            VStack(alignment: .center) {
                                
                                HStack {
                                    Text("Home")
                                        .font(.largeTitle)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .padding(.bottom, 10)
                                    
                                    Spacer()
                                }
                                .frame(maxWidth: geo.size.width > 1200 ? 1200 : 800 )
                                
                                HStack {
                                    Text("Apply your Swift skills by building real-world application")
                                        .font(
                                            Font.custom("Inter", size: 17)
                                                .weight(.bold)
                                                
                                        )
                                        .padding(.bottom, 50)
                                        .foregroundColor(Color(red: 0.85, green: 0.85, blue: 0.85).opacity(0.6))
                                        
                                    
                                    Spacer()
                                }
                                .frame(maxWidth: geo.size.width > 1200 ? 1200 : 800 )
                             
                                
                                HStack {
                                    Text("For you")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                }
                                .frame(maxWidth: geo.size.width > 1200 ? 1200 : 800 )
                                
                                ResponsiveStack {
                                    CardThingy(
                                        selection: $selection,
                                        chapterNumber: currentChapterNumber,
                                        chapterTitle: currentChapterTitle,
                                        levelTitle: currentLevelTitle
                                    )
                                    ProjectsCard(selection: $selection, projects: projects, userData: userData)
                                }
                                
                                Spacer()
                                    .frame(height: 53)
                                
                                
                                
                                VStack {
                                    
                                    HStack {
                                        Text("Progress")
                                            .font(.title2)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                        
                                        Spacer()
                                    }
                                    .frame(maxWidth: geo.size.width > 1200 ? 1200 : 800 )

                                    ResponsiveStack2 {
                                        
                                        ProgressCard(completedModules: userData.currentLevel, totalModules: modules.count)
                                        ActiveLearningCard(last7DayActivity: userData.last7DayActivity, totalActiveDays: userData.totalActiveDays)
                                        
                                    }
                                    .padding(.bottom, 53)
                                }
                                
                                
                                
                                
                                
                                

                                
                                
                                
                                HStack {
                                    Text("Resources")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                }
                                .frame(maxWidth: geo.size.width > 1200 ? 1200 : 800 )
                                //                        ResourceCardScrollableThingy()
                                
                                let rows = [
                                    GridItem(.fixed(200)) //
                                ]
                                ScrollView (.horizontal, showsIndicators: false) {
                                    LazyHGrid(rows: rows, spacing: 50) {
                                        ResourceCard(
                                            title: "SwiSekai",
                                            description: "The Home of SwiSekai",
                                            image: Image("SwiSekaiWeb"), // or Image(systemName: "photo")
                                            link: URL(string: "https://swiftsekai.framer.website/")!
                                        )
                                        
                                        ResourceCard(
                                            title: "Apple Developer Academy Bali",
                                            description: "Apply now to join Cohort 2026 at Apple Developer Academy Indonesia. We are also pleased to announce a new addition to the Apple Developer Academy community, located in Central Jakarta.",
                                            image: Image("Apple Developer"), // or Image(systemName: "photo")
                                            link: URL(string: "https://developeracademy.apps.binus.ac.id/bali/")!
                                        )
                                        ResourceCard(
                                            title: "WWDC25",
                                            description: "Access 100+ new videos with sessions, transcripts, docs, and sample code all in one place.",
                                            image: Image("WWDC25"), // or Image(systemName: "photo")
                                            link: URL(string: "https://developer.apple.com/wwdc25/")!
                                        )
                                       
                                       
                                        
                                    }
                                    .padding(.horizontal) // optional, just to not stick to screen edge
                                }
                                .frame(maxWidth: geo.size.width < 1235 ? 800 : .infinity)
                                
                                
                            }
                           
                        }
                        .frame(maxWidth: 1200)
                        //                        .background(.blue)
                    }
                    .frame(maxWidth: 1200)
                    .padding(.vertical, 20)
                    .padding(.horizontal, 20)
                    
                    Spacer()
                }
            }
        }
        .padding()
    }
}



//struct ResourceCardScrollableThingy: View {
//    @Environment(\.containerLayout) private var containerLayout
//    
//    let rows = [
//        GridItem(.fixed(200)) //
//    ]
//    
//    var body: some View {
//        ScrollView(.horizontal, showsIndicators: false) {
//            LazyHGrid(rows: rows, spacing: 50) {
//                ResourceCard(
//                    title: "WWDC25",
//                    description: "Access 100+ new videos with sessions, transcripts, docs, and sample code all in one place.",
//                    image: Image("Apple Developer Academy"), // or Image(systemName: "photo")
//                    link: URL(string: "https://developer.apple.com/wwdc25/")!
//                )
//                ResourceCard(
//                    title: "WWDC25",
//                    description: "Access 100+ new videos with sessions, transcripts, docs, and sample code all in one place.",
//                    image: Image("Apple Developer Academy"), // or Image(systemName: "photo")
//                    link: URL(string: "https://developer.apple.com/wwdc25/")!
//                )
//                ResourceCard(
//                    title: "WWDC25",
//                    description: "Access 100+ new videos with sessions, transcripts, docs, and sample code all in one place.",
//                    image: Image("Apple Developer Academy"), // or Image(systemName: "photo")
//                    link: URL(string: "https://developer.apple.com/wwdc25/")!
//                )
//            }
//            .padding(.horizontal) // optional, just to not stick to screen edge
//            
//        }
//    }
//}




@ViewBuilder
private func ResponsiveStack<Content: View>(
    @ViewBuilder content: () -> Content
) -> some View {
    ViewThatFits(in: .horizontal) {
        // When HStack is active, tell children the layout is horizontal
        HStack(alignment: .top, spacing: 20) { content() }
            .environment(\.containerLayout, .horizontal)
        
        
        // When VStack is active, tell children the layout is vertical
        VStack(alignment: .leading, spacing: 20) { content() }
            .environment(\.containerLayout, .vertical)
    }
}

@ViewBuilder
private func ResponsiveStack2<Content: View>(
    @ViewBuilder content: () -> Content
) -> some View {
    ViewThatFits(in: .horizontal) {
        // When HStack is active, tell children the layout is horizontal
        HStack(alignment: .top, spacing: 20) { content() }
            .frame(minWidth: 1195, maxWidth: .infinity)
            .environment(\.containerLayout, .horizontal)
        
        
        // When VStack is active, tell children the layout is vertical
        VStack(alignment: .leading, spacing: 20) { content() }
            .frame(maxWidth: 800)
            .environment(\.containerLayout, .vertical)
    }
}

@ViewBuilder
private func ResponsiveStack3<Content: View>(
    @ViewBuilder content: () -> Content
) -> some View {
    ViewThatFits(in: .horizontal) {
        // When HStack is active, tell children the layout is horizontal
        ScrollView { content() }
            .frame(maxWidth: .infinity)
            .environment(\.containerLayout, .horizontal)
        
        
        // When VStack is active, tell children the layout is vertical
        ScrollView { content() }
            .frame(maxWidth: 800)
            .environment(\.containerLayout, .vertical)
    }
}


#Preview {
    enum NavigationItem {
        case home, projects
    }
    return HomeScreen(selection: .constant(.home))
        .modelContainer(for: UserData.self, inMemory: true)
}
