//
//  ContentView.swift
//  SwiSekai
//
//  Created by Agustio Maitimu on 12/08/25.
//

import SwiftUI

struct ContentView: View {
	var body: some View {
		NavigationStack {
			//		ModuleDetailView(module: DataManager.shared.moduleCollection.modules[0])
			ProjectDetailView(project: DataManager.shared.projectCollection.projects[0])
		}
	}
}

#Preview {
	ContentView()
}
