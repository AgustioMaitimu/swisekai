//
//  LevelView.swift
//  SwiSekai
//
//  Created by Adrian Yusufa Rachman on 12/08/25.
//

import SwiftData
import SwiftUI

// MARK: - Main Level View
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
    
    // MARK: - Wave Settings
    let waveAmplitude: CGFloat = 220
    let verticalSpacing: CGFloat = 130
    
    var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
                ScrollView {
                    Spacer().frame(height: 30)
                    
                    ForEach(chapters.indices, id: \.self) { chapterIndex in
                        let chapter = chapters[chapterIndex]
                        
                        ChapterButton(chapterName: chapter.chapterName, status: chapterStatus(for: chapter))
                        
                        ZStack {
                            // Calculations remain the same
                            let itemCount = chapter.modules.count
                            let tempHeightForFreq = verticalSpacing * CGFloat(max(itemCount + 2, 1))
                            let cycleCount = CGFloat(max((itemCount - 1) / 2, 1))
                            let waveFrequency = cycleCount * (2 * CGFloat.pi) / (tempHeightForFreq / verticalSpacing)
                            
                            let positions = insertQuizzes(
                                between: peakTroughPositions(
                                    for: chapter.modules,
                                    waveFrequency: waveFrequency
                                ),
                                verticalSpacing: verticalSpacing
                            )
                            
                            let lastYPosition = positions.last?.y ?? 0
                            let totalHeight = lastYPosition + verticalSpacing * 2.5
                            
                            GeometryReader { geo in
                                ForEach(positions.indices, id: \.self) { i in
                                    positionView(
                                        for: positions[i],
                                        in: chapter,
                                        geo: geo,
                                        waveFrequency: waveFrequency
                                    )
                                }
                                
                                if let lastPos = positions.last {
                                    let finalReviewStatus = self.finalReviewStatus(for: chapter)
                                    
                                    NavigationLink(destination: FinalReviewView(finalReview: chapter.finalReview)) {
                                        FinalReviewButton(status: finalReviewStatus)
                                    }
                                    .buttonStyle(.plain)
                                    .disabled(finalReviewStatus == .unavailable)
                                    .position(
                                        x: geo.size.width / 2,
                                        y: (lastPos.y + verticalSpacing) + 240
                                    )
                                }
                            }
                            .offset(y: -30)
                            .frame(height: totalHeight)
                        }
                        .padding(.bottom, 200)
                    }
                }
            }
            .background(Color("BackgroundColor"))
            .navigationTitle("Learn")
        }
    }
    
    @ViewBuilder
    private func positionView(
        for pos: (y: CGFloat, isPeak: Bool, isQuiz: Bool, index: Int),
        in chapter: Chapter,
        geo: GeometryProxy,
        waveFrequency: CGFloat
    ) -> some View {
        
        if pos.isQuiz {
            let precedingModule = chapter.modules[pos.index]
            let quizStatus = quizStatus(for: precedingModule) // Use precedingModule for status
            
            NavigationLink(destination: MultipleChoiceView(module: precedingModule, userData: userData)) {
                QuizIconView(status: quizStatus)
            }
            .buttonStyle(.plain)
            .disabled(quizStatus == .unavailable)
            .position(
                x: geo.size.width / 2,
                y: pos.y + 50
            )
            
        } else {
            let module = chapter.modules[pos.index]
            let xOffset = -waveAmplitude * sin((pos.y / verticalSpacing) * waveFrequency)
            let status = moduleStatus(for: module)
            
            NavigationLink(destination: ModuleDetailView(module: module)) {
                EmptyView()
            }
            .buttonStyle(ModuleNavigationLinkStyle(
                moduleName: module.moduleName,
                status: status
            ))
            .disabled(status == .unavailable)
            .position(
                x: geo.size.width / 2 + xOffset,
                y: pos.y + 50
            )
        }
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
    
    // ✅ FIX 2: Renamed function from finalTestStatus to finalReviewStatus
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
    
    private func peakTroughPositions(for modules: [Module], waveFrequency: CGFloat) -> [(y: CGFloat, isPeak: Bool)] {
        var positions: [(y: CGFloat, isPeak: Bool)] = []
        
        for n in 0..<modules.count {
            let y = (verticalSpacing / waveFrequency) * (CGFloat(n) * CGFloat.pi + (CGFloat.pi / 2.0))
            let isPeak = n % 2 == 0
            positions.append((y: y, isPeak: isPeak))
        }
        
        guard let firstY = positions.first?.y else {
            return []
        }
        
        let startingGap: CGFloat = 100.0
        
        return positions.map { (y, isPeak) in
            return (y: y - firstY + startingGap, isPeak: isPeak)
        }
    }
    
    private func insertQuizzes(
        between positions: [(y: CGFloat, isPeak: Bool)],
        verticalSpacing: CGFloat
    ) -> [(y: CGFloat, isPeak: Bool, isQuiz: Bool, index: Int)] {
        
        var result: [(y: CGFloat, isPeak: Bool, isQuiz: Bool, index: Int)] = []
        
        for i in 0..<positions.count {
            let modulePosition = positions[i]
            
            result.append((y: modulePosition.y, isPeak: modulePosition.isPeak, isQuiz: false, index: i))
            
            // The last item in the result list is now a module, so add its quiz
            let quizY = result.last!.y + (verticalSpacing * 1.5)
            result.append((y: quizY, isPeak: false, isQuiz: true, index: i))
        }
        
        return result
    }
}
struct ModuleNavigationLinkStyle: ButtonStyle {
    let moduleName: String
    let status: ModuleStatus
    
    func makeBody(configuration: Configuration) -> some View {
        ModuleIconView(
            moduleName: moduleName,
            status: status,
            isPressed: configuration.isPressed
        )
    }
}

#Preview {
    ModulesView()
}
