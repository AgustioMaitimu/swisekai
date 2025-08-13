//
//  ModuleDetailView.swift
//  SwiSekai
//
//  Created by Agustio Maitimu on 12/08/25.
//

import SwiftUI

struct ModuleDetailView: View {
	let module: Module
	
	var body: some View {
		VStack(alignment: .leading, spacing: 0) {
			Text(module.moduleName)
				.font(.largeTitle)
				.bold()
				.padding()
			
			ContentBlockView(blocks: module.contentBlocks)
		}
		.toolbar {
			Button("Complete") {
				completeModule()
			}
		}
	}
	
	private func completeModule() {
		print("Completing Module on macOS: \(module.moduleName)")
		//userdata.highestLevelCompleted += 1 disini
	}
}

//#Preview {
//    ModuleDetailView()
//}
