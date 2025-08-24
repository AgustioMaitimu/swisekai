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
    
    @State private var isSidebarVisible = false

    var body: some View {
        // Use an HStack to place content and sidebar side-by-side
        HStack(spacing: 0) {
            // Main content area
            ModuleContentView(module: module, userData: userData) {
                withAnimation(.spring()) {
                    isSidebarVisible.toggle()
                }
            }

            if isSidebarVisible {
                ChatbotSidebarView(isShowing: $isSidebarVisible)
                    .frame(width: 500) // Give the sidebar a fixed width
                    .transition(.move(edge: .trailing)) // Keep the slide animation
            }
        }
    }
}

struct ModuleContentView: View {
    let module: Module
    let userData: UserData
    var onChatButtonTapped: () -> Void // Closure to handle the button tap

    var body: some View {
        GeometryReader { geometry in
			ScrollView(showsIndicators: false) {
                VStack(alignment: .center) {
                    // Button is now part of the scrolling content
                    HStack {
                        Spacer()
                        Button(action: onChatButtonTapped) {
                            ChatBotButtonView()
                        }
                        .buttonStyle(.plain)
                    }

                    ContentBlockView(blocks: module.contentBlocks)
                        .padding(.bottom, 20)

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
                .frame(maxWidth: 1000)
            }
            .frame(maxWidth: .infinity)
            .background(.mainBackground)
        }
    }
}

struct ChatBotButtonView: View {
    var body: some View {
        HStack(spacing: 5) {
            Image("BotOnFire")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(.gray)
            
            Text("Ask Taylor 􀆿")
                .font(.subheadline)
                .fontWeight(.bold)
        }
        .padding(10)
        .background(Color("ChatbotMessageColor"))
        .cornerRadius(60)
        .foregroundColor(.white)
    }
}
//#Preview {
//    ModuleDetailView()
//}
