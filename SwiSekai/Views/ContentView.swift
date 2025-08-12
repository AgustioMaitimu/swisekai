//
//  ContentView.swift
//  SwiSekai
//
//  Created by Agustio Maitimu on 12/08/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
		ModuleDetailView(module: DataManager.shared.moduleCollection.modules[1])
//		ProjectDetailView(project: DataManager.shared.projectCollection.projects.first!)
    }
}

#Preview {
    ContentView()
}
