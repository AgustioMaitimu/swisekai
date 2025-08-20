//
//  ModuleDetailView.swift
//  SwiSekai
//
//  Created by Agustio Maitimu on 12/08/25.
//

import SwiftData
import SwiftUI

struct ModuleDetailView: View {
    let module: Module
    @Environment(\.modelContext) private var modelContext
    @Query private var userDataItems: [UserData]
    private var userData: UserData {
        userDataItems.first ?? UserData.shared(in: modelContext)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .center, spacing: 24) {
                    ContentBlockView(blocks: module.contentBlocks)
                    
                    HStack {
                        Spacer()
                        
                        NavigationLink(destination: MultipleChoiceView(module: module, userData: userData)) {
                            Text("Next")
                                .font(geometry.size.width < 700 ? .title3.bold() : .title2.bold())
                                .padding(.horizontal, geometry.size.width < 700 ? 40 : 55)
                                .padding(.vertical, geometry.size.width < 700 ? 12 : 14)
                                .background(Color("ButtonColor"))
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                        .buttonStyle(.plain)
                    }
                    
                    Spacer()
                }
                .padding(.vertical, 30)
                .padding(.horizontal, geometry.size.width < 700 ? 20 : 40)
                .frame(maxWidth: 1000) // Set a max width for better text readability on wide displays.
            }
            .frame(maxWidth: .infinity) // Center the content horizontally.
            .background(.mainBackground)
        }
    }
}

//#Preview {
//    ModuleDetailView()
//}
