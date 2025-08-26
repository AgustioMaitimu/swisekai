//
//  ResourceCard.swift
//  SwiSekai
//
//  Created by Adrian Yusufa Rachman on 25/08/25.
//

import SwiftUI

struct ResourceCard: View {
    @Environment(\.containerLayout) private var containerLayout
    
    var body: some View {
        VStack {
            Rectangle()
                .fill(.gray)
                .frame(width: 392, height: 152)
                .cornerRadius(8)

            Text("WWDC25")
                .font(.title2.weight(.bold))
                .padding(.top,10)
                .padding(.bottom ,4)
                .foregroundColor(.white)
                .frame(maxWidth:.infinity, alignment: .leading)

            Text("Access 100+ new videos with sessions,transcripts, docs, and sample code all in one place.")
                .font(.body)
                .frame(maxWidth:.infinity, alignment: .leading)
                .foregroundColor(.gray)
                .padding(.bottom,4)

            Spacer()

            Button(action: {}) {
                HStack{
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
