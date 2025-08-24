//
//  LevelView.swift
//  SwiSekai
//
//  Created by Adrian Yusufa Rachman on 12/08/25.
//

import SwiftData
import SwiftUI

struct ModuleScrollID: Hashable {
    let id: Int
}

// MARK: - Main Level View (Refactored)
struct ModulesView: View {
    // MARK: - Data
    
    var chapters = DataManager.shared.chapterCollection.chapters
    @Environment(\.modelContext) private var modelContext
    @Query private var userDataItems: [UserData]
    private var userData: UserData {
        userDataItems.first ?? UserData.shared(in: modelContext)
    }
    
    var currentLevel: Int {
        userData.currentLevel
    }
    
    // MARK: - Layout Settings
    // Controls the "waviness" or how far left/right the buttons go.
    let horizontalPadding: CGFloat = 60
    
    var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
				ScrollView(showsIndicators: false) {
                    Spacer().frame(height: 30)
                    
                    // Loop through each chapter
                    ForEach(chapters.indices, id: \.self) { chapterIndex in
                        let chapter = chapters[chapterIndex]
                        
                        ChapterButton(chapterName: chapter.chapterName, status: chapterStatus(for: chapter))
                        
                        // Use a VStack for the main vertical layout of modules and quizzes
                        VStack(spacing: 30) {
                            // Loop through the modules to place them and their corresponding quizzes
                            ForEach(chapter.modules.indices, id: \.self) { moduleIndex in
                                let module = chapter.modules[moduleIndex]
                                let status = moduleStatus(for: module)
                                
                                // MARK: - Module Button Row
                                // Use an HStack to control horizontal alignment
                                HStack {
                                    // Even-indexed modules align left
                                    if moduleIndex % 2 == 0 {
                                        moduleNavigationLink(for: module, status: status)
                                        Spacer()
                                    } else {
                                        // Odd-indexed modules align right
                                        Spacer()
                                        moduleNavigationLink(for: module, status: status)
                                    }
                                }
                                .padding(.horizontal, horizontalPadding)
                                
                                // MARK: - Quiz Button Row
                                let quizStatus = quizStatus(for: module)
                                HStack {
                                    Spacer() // Center the quiz button
                                    NavigationLink(destination: MultipleChoiceView(module: module, userData: userData)) {
                                        QuizIconView(status: quizStatus)
                                    }
                                    .buttonStyle(.plain)
                                    .disabled(quizStatus == .unavailable)
                                    Spacer()
                                }
                            }
                            
                            // MARK: - Final Review Button
                            let finalReviewStatus = self.finalReviewStatus(for: chapter)
                            HStack {
                                Spacer() // Center the final review
                                NavigationLink(destination: FinalReviewView(finalReview: chapter.finalReview)) {
                                    FinalReviewButton(status: finalReviewStatus)
                                }
                                .buttonStyle(.plain)
                                .disabled(finalReviewStatus == .unavailable)
                                Spacer()
                            }
                            .padding(.top, 30) // Add some extra space before the final review
                            
                        }
                        .padding(.vertical, 40)
                        .padding(.bottom, 50)
                        .frame(maxWidth: 650)
                    }
                }
                
                .onAppear {
                    // Scroll logic remains the same and works perfectly
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation(.easeInOut(duration: 1)) {
                            let anchor: UnitPoint = currentLevel < 3 ? .top : .center
                            proxy.scrollTo(ModuleScrollID(id: currentLevel), anchor: anchor)
                        }
                    }
                }
            }
            .background(Color("BackgroundColor"))
            .navigationTitle("Learn")
        }
    }
    
    /// Helper view builder for creating the module navigation link and its style.
    @ViewBuilder
    private func moduleNavigationLink(for module: Module, status: ModuleStatus) -> some View {
        NavigationLink(destination: ModuleDetailView(module: module)) {
            // EmptyView is used because the visual representation is defined in the ButtonStyle
            EmptyView()
        }
        .buttonStyle(ModuleNavigationLinkStyle(
            moduleName: module.moduleName,
            status: status,
            num: module.moduleNumber
        ))
        .disabled(status == .unavailable)
        .id(ModuleScrollID(id: module.moduleNumber)) // Attach the ID here for ScrollViewReader
    }
    
    // MARK: - Buttons status
    private func chapterStatus(for chapter: Chapter) -> ChapterStatus {
        guard let firstModuleNumber = chapter.modules.first?.moduleNumber else {
            return .unavailable
        }
        
        if currentLevel >= firstModuleNumber {
            return .available
        } else {
            return .unavailable
        }
    }
    
    private func moduleStatus(for module: Module) -> ModuleStatus {
        if module.moduleNumber < currentLevel {
            return .finished
        } else if module.moduleNumber == currentLevel {
            return .current
        } else {
            return .unavailable
        }
    }
    
    private func quizStatus(for module: Module) -> QuizStatus {
        // The quiz is available if the user is currently ON the module it follows.
        if module.moduleNumber < currentLevel {
            return .completed
        } else if module.moduleNumber == currentLevel {
            return .available
        } else {
            return .unavailable
        }
    }
    
    private func finalReviewStatus(for chapter: Chapter) -> FinalReviewStatus {
        guard let lastModuleNumberInChapter = chapter.modules.last?.moduleNumber else {
            return .unavailable
        }
        
        if currentLevel > lastModuleNumberInChapter {
            return .completed
        } else if currentLevel == lastModuleNumberInChapter + 1 { // Available after the final quiz
            return .available
        } else {
            return .unavailable
        }
    }
}

// ModuleNavigationLinkStyle and Preview remain the same
struct ModuleNavigationLinkStyle: ButtonStyle {
    let moduleName: String
    let status: ModuleStatus
    let num: Int
    
    func makeBody(configuration: Configuration) -> some View {
        HStack{
            ModuleIconView(
                moduleName: moduleName,
                status: status,
                isPressed: configuration.isPressed
            )
        }
    }
}

#Preview {
    ModulesView()
}
