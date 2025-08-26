//
//  ResourceCard.swift
//  SwiSekai
//
//  Created by Adrian Yusufa Rachman on 25/08/25.
//

import SwiftUI

struct ResourceCard: View {
    let title: String
    let description: String
    let image: Image        // can use Image("...") or Image(systemName: "...")
    let link: URL
    
    @Environment(\.openURL) private var openURL
    
    var body: some View {
        VStack {
            image
                .resizable()
                .scaledToFill()
                .frame(width: 392, height: 152)
                .clipped()
                .cornerRadius(8)

            Text(title)
                .font(.title2.weight(.bold))
                .padding(.top,10)
                .padding(.bottom ,4)
                .foregroundColor(.white)
                .frame(maxWidth:.infinity, alignment: .leading)

            Text(description)
                .font(.body)
                .frame(maxWidth:.infinity, alignment: .leading)
                .foregroundColor(.gray)
                .padding(.bottom,4)

            Spacer()

            Button(action: {
                openURL(link)
            }) {
                HStack {
                    Spacer()
                    Image(systemName: "arrow.up.forward.app.fill")
                    Text("OPEN")
                    Spacer()
                }
                .font(.headline.weight(.medium))
                .foregroundColor(.white)
                .padding()
                .frame(height: 42)
                .background(.blue)
                .cornerRadius(8)
            }
            .buttonStyle(.plain)
        }
        .padding()
        .background(.black.opacity(0.3))
        .cornerRadius(12)
        .frame(width: 392, height: 336)
    }
}

#Preview {
    ResourceCard(
        title: "WWDC25",
        description: "Access 100+ new videos with sessions, transcripts, docs, and sample code all in one place.",
        image: Image("Apple Developer Academy"), // or Image(systemName: "photo")
        link: URL(string: "https://developer.apple.com/wwdc25/")!
    )
}
