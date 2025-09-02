//
//  ProjectsCard.swift
//  SwiSekai
//
//  Created by Adrian Yusufa Rachman on 25/08/25.
//

import SwiftUI

struct ProjectsCard: View {
    // to read containerLayout value from environment
    @Environment(\.containerLayout) private var containerLayout
    
    @Binding var selection: NavigationItem
    let projects: [Project]
    let userData: UserData
    
    // Circle size used for the completion indicator
    private var circleSize: CGFloat {
        containerLayout == .horizontal ? 45 : 36
    }
    // Stroke width scales with the circle so it stays proportionate and thinner
    private var ringLineWidth: CGFloat {
        max(4, circleSize * 0.15)
    }
    
    // This computed property now contains the correct logic from your original view
    private var finalProjects: [Project] {
        let unlockedProjects = projects.filter { $0.levelPrerequisite <= userData.currentLevel && !userData.completedProjects.contains($0.id) }
        let lockedProjects = projects.filter { $0.levelPrerequisite > userData.currentLevel }
        
        let projectsToShow = Array(unlockedProjects.prefix(3))
        let remainingSlots = 3 - projectsToShow.count
        let lockedProjectsToShow = Array(lockedProjects.prefix(remainingSlots))
        
        return projectsToShow + lockedProjectsToShow
    }
    
    // A simple way to calculate project completion percentage
    private var projectCompletionPercentage: Int {
        guard !projects.isEmpty else { return 0 }
        return Int((Double(userData.completedProjects.count) / Double(projects.count)) * 100)
    }
    
    private var displayProjects: [Project] {
        if containerLayout == .horizontal { return finalProjects }
        return Array(finalProjects.prefix(2))
    }

    var body: some View {
        VStack {
            Text("Projects")
                .font(
                    Font.custom("SF Pro", size: 20)
                        .weight(.bold)
                )
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 25)
                .padding(.bottom, 15)
            
            VStack(spacing: containerLayout == .horizontal ? 12 : 10) {
                ForEach(displayProjects) { project in
                    let isLocked = project.levelPrerequisite > userData.currentLevel
                    NavigationLink(destination: ProjectDetailView(project: project)) {
                        HStack {
                            Text(project.projectName)
                                .font(Font.custom("SF Pro", size: containerLayout == .horizontal ? 20 : 18).weight(.medium))
                                .foregroundStyle(.black)
                            Spacer()
                            Image(systemName: isLocked ? "lock.fill" : "chevron.right")
                                .foregroundColor(.black)
                                .padding(.trailing, 10)
                                .bold(true)
                        }
                        .padding(.horizontal, containerLayout == .horizontal ? 18 : 14)
                        .padding(.vertical, containerLayout == .horizontal ? 12 : 10)
                        .frame(maxWidth: .infinity, minHeight: containerLayout == .horizontal ? 44 : 40, alignment: .leading)
                        .background(Color(red: 0.91, green: 0.91, blue: 0.91))
                        .cornerRadius(100)
                    }
                    .buttonStyle(.plain)
                    .disabled(isLocked)
                }
            }
            .padding(.bottom, 20)
            
          HStack {
                ZStack {
                    // This is the background of the arc, making it look complete.
                    Circle()
                        .stroke(lineWidth: ringLineWidth)
                        .opacity(1)
                        .foregroundColor(Color.white)
                    
                    // This is the progress arc that will fill up based on the percentage.
                    Circle()
                        .trim(from: 0.0, to: CGFloat(min(Double(projectCompletionPercentage) / 100.0, 1.0)))
                        .stroke(style: StrokeStyle(lineWidth: ringLineWidth, lineCap: .square, lineJoin: .miter))
                        .fill(
                            LinearGradient(
                                gradient: Gradient(stops: [
                                    .init(color: Color(red: 0.99, green: 0.76, blue: 0.47), location: 0.00),
                                    .init(color: Color(red: 0.98, green: 0.29, blue: 0.13), location: 1.00),
                                ]),
                                startPoint: UnitPoint(x: 0.5, y: 0),
                                endPoint: UnitPoint(x: 0.5, y: 1)
                            )
                        )
                        // This rotation makes the arc start from the right side.
                        .rotationEffect(Angle(degrees: 90.0))
                    
                    // The percentage text is placed in the center of the ZStack.
                    Text("\(projectCompletionPercentage)%")
                        .font(.system(size: circleSize * 0.25, weight: .bold))
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                        .allowsTightening(true)
                        // Constrain text within inner circle area, accounting for ring thickness + small padding
                        .frame(width: circleSize - (ringLineWidth * 2 + 4))
                        .foregroundColor(.white)
                }
                // Set a fixed size for the progress arc view.
                .frame(width: circleSize, height: circleSize)
                .padding(.leading, 10)
               

                // --- New Code Block ---
                // This VStack holds the project completion count and label.
              
                    Text("\(userData.completedProjects.count)/\(projects.count)")
                        .font(Font.custom("SF Pro", size: containerLayout == .horizontal ? 20 : 18))
                        .foregroundColor(.white)
                    
                   
                
                .padding(.leading, 15) // Add spacing between the arc and the text
                // --- End of New Code Block ---

                Spacer()
                
                Button {
                    selection = .projects
                } label: {
                    Text("All projects")
                        .font(
                            Font.custom("SF Pro", size: containerLayout == .horizontal ? 20 : 18)
                                .weight(.medium)
                        )
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Color(red: 0.04, green: 0.52, blue: 1))
                        .cornerRadius(100)
                       
                }
                .buttonStyle(.plain)
                .padding(.trailing, 4)
            }
          .padding(.vertical, 8)
          .padding(.bottom, 22)
        }
        .padding(.horizontal, 32)
        .modifier(ProjectsCardSizer(layout: containerLayout))
        .background(Color(red: 0.13, green: 0.13, blue: 0.13))
        
        
        .cornerRadius(20)
    }
}

private struct ProjectsCardSizer: ViewModifier {
    let layout: Axis
    func body(content: Content) -> some View {
        Group {
            if layout == .horizontal {
                content
                    .frame(width: 460)
                    .frame(minHeight: 345)
            } else {
                content
                    .frame(minWidth: 200, maxWidth: .infinity)
                    .frame(maxHeight: 260)
            }
        }
    }
}


#Preview {
    // Use a NavigationStack to ensure NavigationLinks work in the preview.
    NavigationStack {
        // We create a state variable for the selection binding.
        // .constant() is used for previews where the state doesn't need to change.
        ProjectsCard(
            selection: .constant(.home),
            
            // Create an array of sample projects to display in the card.
            // This data mimics what would be loaded from your YAML files.
            projects: [
                // An unlocked project
                Project(id: UUID(), projectName: "Player Score Tracker", contentBlocks: [], levelPrerequisite: 1, projectDifficulty: "Easy", projectDescription: ""),
                // Another unlocked project
                Project(id: UUID(), projectName: "Greeting Card Generator", contentBlocks: [], levelPrerequisite: 2, projectDifficulty: "Easy", projectDescription: ""),
                // A locked project
                Project(id: UUID(), projectName: "To-Do List Manager", contentBlocks: [], levelPrerequisite: 5, projectDifficulty: "Medium", projectDescription: "")
            ],
            
            // Create a sample UserData object for the preview.
            userData: {
                let userData = UserData()
                userData.currentLevel = 3 // Set the user's level to 3
                userData.completedProjects = [UUID()] // Add a dummy completed project
                return userData
            }()
        )
        .padding()
    }
    .background(Color.black) // Add a background for better visibility
    // This modifier provides an in-memory database for SwiftData models
    // which is essential for previewing views that use @Query.
    .modelContainer(for: UserData.self, inMemory: true)
}
