//
//  ContentView.swift
//  SwiSekai
//
//  Created by Agustio Maitimu on 12/08/25.
//

import SwiftUI

struct ContentView: View {
    let modules = DataManager.shared.moduleCollection.modules
    let projects = DataManager.shared.projectCollection.projects
    var body: some View {
        NavigationStack {
            List(modules) { module in
                NavigationLink(destination: ModuleDetailView(module: module)){
                    Text(module.moduleName)
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color("BackgroundColor"))
        }
    }
}

#Preview {
    ContentView()
}
