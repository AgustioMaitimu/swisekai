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
        VStack(alignment: .leading, spacing: 8) {
            image
                .resizable()
                .scaledToFill()
                .frame(height: 120)
                .frame(maxWidth: .infinity)
                .clipped()
                .cornerRadius(8)

            Text(title)
                .font(.headline.weight(.bold))
                .padding(.top, 6)
                .foregroundColor(.white)
                .lineLimit(1)
                .truncationMode(.tail)
                .frame(maxWidth:.infinity, alignment: .leading)

            Text(description)
                .font(.subheadline)
                .foregroundColor(.gray)
                .lineLimit(2)
                .frame(maxWidth:.infinity, alignment: .leading)

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
                .font(.subheadline.weight(.semibold))
                .foregroundColor(.white)
                .padding(.horizontal)
                .padding(.vertical, 10)
                .frame(height: 36)
                .background(.blue)
                .cornerRadius(8)
            }
            .buttonStyle(.plain)
        }
        .padding(12)
        .background(.black.opacity(0.3))
        .cornerRadius(12)
        .frame(width: 360, height: 270)
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
