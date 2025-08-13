//
//  ProjectDetailView.swift
//  SwiSekai
//
//  Created by Agustio Maitimu on 12/08/25.
//

import SwiftUI

struct ProjectDetailView: View {
	let project: Project
	
	var body: some View {
		VStack(alignment: .leading, spacing: 0) {
			Text(project.projectName)
				.font(.largeTitle)
				.bold()
				.padding()
			
			ContentBlockView(blocks: project.contentBlocks)
		}
		.toolbar {
			Button("Complete") {
				completeProject()
			}
		}
	}
	
	private func completeProject() {
		print("Completing Project on macOS: \(project.projectName)")
		//userdata.completedProjects.insert(project.project_name) disini
	}
}

//#Preview {
//    ProjectDetailView()
//}
