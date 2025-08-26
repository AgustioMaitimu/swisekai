//
//  CardThingy.swift
//  SwiSekai
//
//  Created by Adrian Yusufa Rachman on 25/08/25.
//

import SwiftUI

struct CardThingy: View {
    @Environment(\.containerLayout) private var containerLayout
    
    @Binding var selection: NavigationItem
    let chapterNumber: Int
    let chapterTitle: String
    let levelTitle: String
    
    var body: some View {
        Group {
            if containerLayout == .horizontal {
                // ZStack layout
                ZStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        Text("Chapter \(chapterNumber)")
                            .font(Font.custom("SF Pro", size: 20).weight(.bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.bottom, 1)
                        
                        Text(chapterTitle.dropFirst(11))
                            .font(Font.custom("SF Pro", size: 48).weight(.bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Text(levelTitle)
                            .font(Font.custom("SF Pro", size: 32).weight(.medium))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    
                    Spacer()
                    
                    Button {
                        selection = .learn
                    } label: {
                        Text("Continue")
                            .font(Font.custom("SF Pro", size: 20).weight(.medium))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                            .padding(.vertical, 16)
                            .foregroundColor(.white)
                            .frame(width: 254)
                            .background(Color.blue)
                            .cornerRadius(100)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .buttonStyle(.plain)
                    .offset(x: 0, y: 170) // only in horizontal
                }
            } else {
                // VStack layout
                VStack(alignment: .leading, spacing: 20) {
                    Text("Chapter \(chapterNumber)")
                        .font(Font.custom("SF Pro", size: 20).weight(.bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(chapterTitle.dropFirst(11))
                        .font(Font.custom("SF Pro", size: 48).weight(.bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Text(levelTitle)
                        .font(Font.custom("SF Pro", size: 32).weight(.medium))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Spacer()
                    
                    Button {
                        selection = .learn
                    } label: {
                        Text("Continue")
                            .font(Font.custom("SF Pro", size: 20).weight(.medium))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                            .padding(.vertical, 16)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity) // fills width
                            .background(Color.blue)
                            .cornerRadius(100)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(30)
        .frame(
            minWidth: containerLayout == .horizontal ? 800 : 100,
            maxWidth: containerLayout == .horizontal ? .infinity : 800,
            maxHeight: .infinity,
            alignment: .topLeading
        )
        .background(
            LinearGradient(
                stops: [
                    .init(color: Color(red: 0.98, green: 0.63, blue: 0.25), location: 0),
                    .init(color: Color(red: 0.94, green: 0.27, blue: 0.2), location: 1),
                ],
                startPoint: UnitPoint(x: 0.82, y: -0.12),
                endPoint: UnitPoint(x: 0.27, y: 1.06)
            )
        )
        .cornerRadius(20)
    }
}


#Preview {
    CardThingy(
        selection: .constant(.learn),
        chapterNumber: 1,
        chapterTitle: "Chapter 1: Swift Data Types",
        levelTitle: "Beginner"
    )
    
    .padding()
    .background(Color.black)
}

