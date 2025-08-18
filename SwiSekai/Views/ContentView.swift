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
			.background(.mainBackground)
        }
    }
}

#Preview {
	ContentView()
}












































////
////  ContentView.swift
////  SwiSekai
////
////  Created by Agustio Maitimu on 12/08/25.
////
//
//import SwiftUI
//
//struct ResponsiveNavBarView: View {
//    var body: some View {
//		ModuleDetailView(module: DataManager.shared.moduleCollection.modules[1])
////		ProjectDetailView(project: DataManager.shared.projectCollection.projects[2])
//    }
//}
//
//#Preview {
//    ModulesView()
//}
