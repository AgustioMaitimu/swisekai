//
//  FinalTestView.swift
//  SwiSekai
//
//  Created by Ryan Hangralim on 19/08/25.
//

import SwiftUI

struct FinalTestView: View {
    let finalReview: FinalReview

        var body: some View {
            GeometryReader { geometry in
                ScrollView {
                    VStack(alignment: .center, spacing: 24) {
                        ContentBlockView(blocks: finalReview.contentBlocks)
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
