//
//  ModuleDetailView.swift
//  SwiSekai
//
//  Created by Agustio Maitimu on 12/08/25.
//

import SwiftUI

struct ProjectDetailView: View {
	let project: Project
	
	var body: some View {
		VStack(alignment: .center, spacing: 16) {
			ContentBlockView(blocks: project.contentBlocks)
			Spacer()
		}
		.frame(width: 800)
		.padding(.vertical)
		.frame(maxWidth: .infinity)
		.background(.mainBackground)
}

private func completeModule() {
	print("Completing Module on macOS: \(project.projectName)")
	//userdata.completeProject() disini
}
}

//#Preview {
//    ModuleDetailView()
//}
