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
                VStack(alignment: .leading, spacing: 12) {
                    Text("Chapter \(chapterNumber)")
                        .font(Font.custom("SF Pro", size: 20).weight(.bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(chapterTitle.dropFirst(11))
                        .font(Font.custom("SF Pro", size: 42).weight(.bold))
                        .foregroundColor(.white)
                        .lineLimit(2)
                        .minimumScaleFactor(0.75)
                        .allowsTightening(true)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .fixedSize(horizontal: false, vertical: true)
                    Text(levelTitle)
                        .font(Font.custom("SF Pro", size: 28).weight(.medium))
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                        .allowsTightening(true)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer(minLength: 8)
                    HStack {
                        Spacer()
                        Button {
                            selection = .learn
                        } label: {
                            Text("Continue")
                                .font(Font.custom("SF Pro", size: 18).weight(.medium))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 12)
                                .foregroundColor(.white)
                                .background(Color.blue)
                                .cornerRadius(100)
                        }
                        .buttonStyle(.plain)
                    }
                }
            } else {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Chapter \(chapterNumber)")
                        .font(Font.custom("SF Pro", size: 18).weight(.bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(chapterTitle.dropFirst(11))
                        .font(Font.custom("SF Pro", size: 32).weight(.bold))
                        .foregroundColor(.white)
                        .lineLimit(2)
                        .minimumScaleFactor(0.7)
                        .allowsTightening(true)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .fixedSize(horizontal: false, vertical: true)
                    Text(levelTitle)
                        .font(Font.custom("SF Pro", size: 20).weight(.medium))
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                        .allowsTightening(true)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer(minLength: 8)
                    Button {
                        selection = .learn
                    } label: {
                        Text("Continue")
                            .font(Font.custom("SF Pro", size: 18).weight(.medium))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(100)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(24)
        .frame(
            minWidth: 320,
            maxWidth: .infinity,
            alignment: .topLeading
        )
        .modifier(ChapterCardSizer(layout: containerLayout))
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

private struct ChapterCardSizer: ViewModifier {
    let layout: Axis
    func body(content: Content) -> some View {
        if layout == .vertical {
            content.frame(maxHeight: 260)
        } else {
            content
        }
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
