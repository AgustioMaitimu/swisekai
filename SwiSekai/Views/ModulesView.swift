//
//  LevelView.swift
//  SwiSekai
//
//  Created by Adrian Yusufa Rachman on 12/08/25.
//

import SwiftUI

// MARK: - Main Level View
struct ModulesView: View {
    // MARK: - Data
    // Gets module data from database
    var collections = DataManager.shared.moduleCollection.modules
    var highestCompletedLevel: Int = 4
    
    // Placeholder quiz names (TODO: Replace with DB data later)
    var quizzes = ["balls", "squares", "triangles"]
    
    // MARK: - Wave Settings
    let waveAmplitude: CGFloat = 180      // Horizontal distance from wave center to peak
    let verticalSpacing: CGFloat = 230    // Vertical distance between peaks/troughs
    
    var body: some View {
        // Wrap in NavigationStack to enable navigation
        NavigationStack {
            // MARK: - Wave Calculations
            let itemCount = collections.count
            
            // Total height of the scrollable area (modules + some extra space)
            let totalHeight = verticalSpacing * CGFloat(max(itemCount + 2, 1))
            
            // Number of sine wave cycles to draw based on item count
            let cycleCount = CGFloat(max((itemCount - 1) / 2, 1))
            
            // Frequency of the sine wave (controls how "stretched" it is vertically)
            let waveFrequency = cycleCount * (2 * .pi) / (totalHeight / verticalSpacing)
            
            // Generate positions for modules & quizzes
            let positions = insertQuizzes(
                between: peakTroughPositions(
                    maxHeight: totalHeight,
                    waveFrequency: waveFrequency
                )
            )
            
            // MARK: - Main UI
            ScrollView {
                Spacer().frame(height: 30) // Top margin
                ChapterButton()
                
                ZStack {
                    // Uncomment if you want to draw the sine path background
                    /*
                    GeometryReader { geo in
                        SinePathView(
                            verticalSpacing: verticalSpacing,
                            waveAmplitude: waveAmplitude,
                            waveFrequency: waveFrequency,
                            totalHeight: totalHeight
                        )
                        .offset(x: geo.size.width / 2, y: 50)
                    }
                    */
                    
                    GeometryReader { geo in
                        // Place each module/quiz on the sine wave
                        ForEach(positions.indices, id: \.self) { i in
                            positionView(
                                for: positions[i],
                                geo: geo,
                                waveFrequency: waveFrequency
                            )
                        }
                        
                        // Place the final test button at the end of the sine wave
                        if let lastPos = positions.last {
                            let finalYOffset = lastPos.y + verticalSpacing // Push below last item
                            let finalXOffset = waveAmplitude * sin((finalYOffset / verticalSpacing) * waveFrequency)
                            
                            FinalTestButton()
                                .position(
                                    x: geo.size.width / 2 + finalXOffset,
                                    y: finalYOffset + 20
                                )
                        }
                    }
                }
                .frame(height: totalHeight + 100)
                .padding(.top, 200)
                .padding(.bottom, 100)
            }
			.background(Color.mainBackground) // Dark gray background
            .navigationTitle("Learn")
        }
    }
    
    // MARK: - Helper: Positioning Individual Items
    private func positionView(
        for pos: (y: CGFloat, isPeak: Bool, isQuiz: Bool, index: Int),
        geo: GeometryProxy,
        waveFrequency: CGFloat
    ) -> some View {
        
        // X offset from sine wave formula
        let xOffset = waveAmplitude * sin((pos.y / verticalSpacing) * waveFrequency)
        
        // Use AnyView to erase different Button types (avoids generic type inference errors)
        let content: AnyView
        
        if pos.isQuiz {
            // Quiz Button
            content = AnyView(
                Button(action: { print("Tapped Quiz") }) {
                    QuizIconView()
                }
                .buttonStyle(.plain)
            )
        } else {
            // Module NavigationLink
            let collection = collections[pos.index % max(collections.count, 1)]
            let status = moduleStatus(for: pos.index)
            
            content = AnyView(
                NavigationLink(destination: ModuleDetailView(module: collection)) {
                    // The label is empty because the ButtonStyle provides the entire view.
                    EmptyView()
                }
                .buttonStyle(ModuleNavigationLinkStyle(
                    moduleName: collection.moduleName,
                    status: status
                ))
                .disabled(status == .unavailable)
            )
        }
        
        return content
            .position(
                x: geo.size.width / 2 + xOffset,
                y: pos.y + 50
            )
    }

    // MARK: - Helper: Determine Module Status
    private func moduleStatus(for index: Int) -> ModuleStatus {
        if index < highestCompletedLevel {
            return .finished
        } else if index == highestCompletedLevel {
            return .current
        } else {
            return .unavailable
        }
    }

    // MARK: - Helper: Generate peak & trough Y positions of sine wave
    private func peakTroughPositions(maxHeight: CGFloat, waveFrequency: CGFloat)
        -> [(y: CGFloat, isPeak: Bool)]
    {
        var positions: [(y: CGFloat, isPeak: Bool)] = []
        
        // First peak starts a bit above zero
        positions.append((y: -130, isPeak: true))
        
        var n = 0
        while true {
            // Peak position
            let yPeak = verticalSpacing / waveFrequency * (.pi / 2 + 2 * .pi * CGFloat(n))
            if yPeak <= maxHeight {
                positions.append((y: yPeak, isPeak: true))
            } else { break }
            
            // Trough position
            let yTrough = verticalSpacing / waveFrequency * (3 * .pi / 2 + 2 * .pi * CGFloat(n))
            if yTrough <= maxHeight {
                positions.append((y: yTrough, isPeak: false))
            } else { break }
            
            n += 1
        }
        
        // Sort so we draw from top to bottom
        return positions.sorted { $0.y < $1.y }
    }

    // MARK: - Helper: Insert quizzes between peaks & troughs
    private func insertQuizzes(
        between positions: [(y: CGFloat, isPeak: Bool)]
    ) -> [(y: CGFloat, isPeak: Bool, isQuiz: Bool, index: Int)] {
        
        var result: [(y: CGFloat, isPeak: Bool, isQuiz: Bool, index: Int)] = []
        var moduleIndex = 0
        
        for i in 0..<positions.count {
            // Add a module at the peak or trough
            result.append((y: positions[i].y, isPeak: positions[i].isPeak, isQuiz: false, index: moduleIndex))
            moduleIndex += 1
            
            // Add a quiz halfway between two positions
            if i < positions.count - 1 {
                let midY = (positions[i].y + positions[i+1].y) / 2
                result.append((y: midY, isPeak: false, isQuiz: true, index: -1))
            }
        }
        
        return result
    }
}

// This custom style creates the ModuleIconView and passes the pressed state to it.
struct ModuleNavigationLinkStyle: ButtonStyle {
    let moduleName: String
    let status: ModuleStatus

    func makeBody(configuration: Configuration) -> some View {
        ModuleIconView(
            moduleName: moduleName,
            status: status,
            isPressed: configuration.isPressed // Use the pressed state from the style
        )
    }
}

#Preview {
    ModulesView()
}
