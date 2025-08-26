//
//  ModulesList.swift
//  SwiSekai
//
//  Created by Ryan Hangralim on 26/08/25.
//

import SwiftData
import SwiftUI

struct ModulesList: View {
    var chapters = DataManager.shared.chapterCollection.chapters
    var modules = DataManager.shared.moduleCollection.modules
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading, spacing: 8) {
                ForEach(modules, id: \.moduleNumber) { module in
                    Text("Module \(module.moduleNumber)")
                        .font(.title)
                    ContentBlockView(blocks: module.contentBlocks)
                }
            }
            .padding(.vertical, 30)
            .padding(.bottom, 50)
            .padding(.top, 100)
            .frame(maxWidth: 1000)
        }
    }
}

#Preview {
    ModulesList()
}
