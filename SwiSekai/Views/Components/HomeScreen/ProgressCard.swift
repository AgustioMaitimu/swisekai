//
//  ProgressCard.swift
//  SwiSekai
//
//  Created by Adrian Yusufa Rachman on 25/08/25.
//

import SwiftUI

struct ProgressCard: View {
    // to read containerLayout value from environment
    @Environment(\.containerLayout) private var containerLayout
    
    let completedModules: Int
    let totalModules: Int

    private var progress: Double {
        guard totalModules > 0 else { return 0.0 }
        return Double(completedModules) / Double(totalModules)
    }

    private var progressSubtitle: String {
        "You have completed \(completedModules) out of \(totalModules) modules!"
    }

    private var progressPercentageText: String {
        "\(Int(progress * 100))%"
    }

    var body: some View {
        VStack(alignment: .leading){
            Text("Total Progress")
                .font(.title3.weight(.bold))
                .foregroundColor(.white)
                .padding(.bottom, 10)

            Text(progressSubtitle)
                .font(containerLayout == .horizontal ? .title3 : .callout)
                .foregroundColor(.white.opacity(0.8))
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 10)

            

            HStack{
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                       
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.clear)
                            .frame(height: 16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.white, lineWidth: 2)
                            )

                        // Progress fill
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(red: 1, green: 0.58, blue: 0))
                            .frame(width: geo.size.width * CGFloat(progress), height: 14)
                            .padding(.leading, 1)
                    }
                }


                Text(progressPercentageText)
                    .font(containerLayout == .horizontal ? .title2.weight(.bold) : .title3.weight(.bold))
                    .multilineTextAlignment(.trailing)
                    .foregroundColor(.white)
            }
            .frame(maxHeight: 16)
        }
        .padding()
        .frame(maxHeight: containerLayout == .horizontal ? 200 : 160)
        .background(Color(red: 0.13, green: 0.13, blue: 0.13))


        .cornerRadius(12)
    }
}


#Preview {
    VStack {
        ProgressCard(completedModules: 5, totalModules: 10)   // 0% progress

    }
  
}
