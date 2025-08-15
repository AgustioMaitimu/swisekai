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
        VStack(alignment: .center, spacing: 16) {
            ContentBlockView(blocks: module.contentBlocks)
                
            HStack{
                Spacer()
                
                NavigationLink(destination: MultipleChoiceView(module: module)) {
                    Text("Next")
                        .fontWeight(.semibold)
                        .padding(.horizontal, 55)
                        .padding(.vertical, 14)
                        .background(Color("ButtonColor"))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .buttonStyle(.plain)
            }
            
            Spacer()
        }
        .frame(width: 800)
        .padding(.vertical)
        .frame(maxWidth: .infinity)
        .background(Color("BackgroundColor"))
    }
	
	private func completeModule() {
		print("Completing Module on macOS: \(module.moduleName)")
		//userdata.highestLevelCompleted += 1 disini
	}
}

//#Preview {
//    ModuleDetailView()
//}
