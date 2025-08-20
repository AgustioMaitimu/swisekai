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
    
    var highestCompletedLevel: Int {
        userData.highestCompletedLevel
    }
    
    // MARK: - Wave Settings
    let waveAmplitude: CGFloat = 220
    let verticalSpacing: CGFloat = 130
    
    var body: some View {
        NavigationStack {
            ScrollView {
                Spacer().frame(height: 30)
                
                ForEach(chapters.indices, id: \.self) { chapterIndex in
                    let chapter = chapters[chapterIndex]
                    
                    ChapterButton(chapterName: chapter.chapterName)
                    
                    // ✅ CORRECT: The ZStack is now the only item here.
                    ZStack {
                        // ✅ All calculations are moved INSIDE the ZStack.
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
                                let finalTestStatus = self.finalTestStatus(for: chapter)
                                
                                NavigationLink(destination: FinalTestView(finalReview: chapter.finalReview)) {
                                    FinalTestButton(status: finalTestStatus)
                                }
                                .buttonStyle(.plain)
                                .disabled(finalTestStatus == .unavailable)
                                .position(
                                    x: geo.size.width / 2,
                                    y: (lastPos.y + verticalSpacing) + 240
                                )
                            }
                        }
                        .offset(y: -30)
                        
                        // The frame modifier uses the calculated totalHeight.
                        .frame(height: totalHeight)
                    }
                    .padding(.bottom, 200)
                }
                
            }
            .background(Color("BackgroundColor"))
            .navigationTitle("Learn")
        }
    }
    
    private func finalTestStatus(for chapter: Chapter) -> FinalTestStatus {
        // Safely get the number of the last module in the chapter.
        // Use a guard to handle chapters with no modules.
        guard let lastModuleNumberInChapter = chapter.modules.last?.moduleNumber, lastModuleNumberInChapter != 0 else {
            return .unavailable
        }
        
        // Now the logic is much simpler
        if highestCompletedLevel > lastModuleNumberInChapter {
            return .completed
        } else if highestCompletedLevel >= lastModuleNumberInChapter {
            return .available
        } else {
            return .unavailable
        }
    }
    
    private func positionView(
        for pos: (y: CGFloat, isPeak: Bool, isQuiz: Bool, index: Int),
        in chapter: Chapter,
        geo: GeometryProxy,
        waveFrequency: CGFloat
    ) -> some View {
        
        let module = chapter.modules[pos.index]
        let content: AnyView
        
        if pos.isQuiz {
            let precedingModule = chapter.modules[pos.index]
            let precedingModuleStatus = moduleStatus(for: precedingModule)
            let quizIsAvailable = (precedingModuleStatus == .finished || precedingModuleStatus == .current)
            
            content = AnyView(
                NavigationLink(destination: MultipleChoiceView(module: precedingModule, userData: userData)) {
                    QuizIconView(status: quizIsAvailable ? .available : .unavailable)
                }
                    .buttonStyle(.plain)
                    .disabled(!quizIsAvailable)
            )
            
            return content
                .position(
                    x: geo.size.width / 2,
                    y: pos.y + 50
                )
            
        } else {
            let xOffset = -waveAmplitude * sin((pos.y / verticalSpacing) * waveFrequency)
            let status = moduleStatus(for: module)
            
            content = AnyView(
                NavigationLink(destination: ModuleDetailView(module: module)) {
                    EmptyView()
                }
                    .buttonStyle(ModuleNavigationLinkStyle(
                        moduleName: module.moduleName,
                        status: status
                    ))
                    .disabled(status == .unavailable)
            )
            
            return content
                .position(
                    x: geo.size.width / 2 + xOffset,
                    y: pos.y + 50
                )
        }
    }
    
    private func moduleStatus(for module: Module) -> ModuleStatus {
        if module.moduleNumber < highestCompletedLevel {
            return .finished
        } else if module.moduleNumber == highestCompletedLevel {
            return .current
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
            
            if i < positions.count - 1 {
                let nextModuleY = positions[i + 1].y
                let quizY = (modulePosition.y + nextModuleY) / 2
                
                result.append((y: quizY, isPeak: false, isQuiz: true, index: i))
            } else {
                // Add quiz for the last module
                let quizY = modulePosition.y + (verticalSpacing * 1.5) // Adjust this value for spacing
                result.append((y: quizY, isPeak: false, isQuiz: true, index: i))
            }
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
