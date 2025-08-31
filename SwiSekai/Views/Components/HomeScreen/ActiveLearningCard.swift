//
//  ActiveLearningCard.swift
//  SwiSekai
//
//  Created by Adrian Yusufa Rachman on 25/08/25.
//

import SwiftUI

struct ActiveLearningCard: View {
    // to read containerLayout value from environment
    @Environment(\.containerLayout) private var containerLayout
    
    let last7DayActivity: [String]
    let totalActiveDays: Int
    let dayLabels = ["M", "T", "W", "T", "F", "S", "S"]
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 10){
                Text("Past 7 Days")
                    .font(Font.custom("SF Pro", size: 16).weight(.bold))
                    
                    .foregroundColor(.white)
                    .padding(.bottom, 8)
                
                HStack(spacing: 8){
                    ForEach(last7DayActivity.indices, id: \.self) { index in
                        VStack(spacing: 6) {
                            // Conditional view for active vs inactive days
                            if last7DayActivity[index] == "active" {
                                // active days
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color(red: 1, green: 0.58, blue: 0))
                                    .aspectRatio(1, contentMode: .fit)
                                
                                
                            } else {
                                // inactive days
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.clear)
                                    .aspectRatio(1, contentMode: .fit)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 4)
                                            .stroke(Color.gray, lineWidth: containerLayout == .horizontal ? 3 : 2)
                                    )
                                
                            }
                            
                            // Day label (optional)
//                            Text(dayLabels[index])
//                                .font(
//                                    Font.custom("SF Pro", size: 20)
//                                        .weight(.bold)
//                                )
//                                .foregroundColor(index == 6 ? .red : .white)
                        }
                    }
                }
                
            }
            
            VStack(alignment: .trailing, spacing: 2) {
                Text("Total Learning")
                    .font(.system(size: 16, weight: .bold))
                    .minimumScaleFactor(0.9)
                    .foregroundColor(.white)

                Text("\(totalActiveDays) Days")
                    .font(.system(size: 28, weight: .bold))
                    .minimumScaleFactor(0.8)
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity, alignment: .trailing) // push VStack to right side
            .padding(.horizontal, 28)

        }
        .padding(20)
        //        .frame(minHeight: 132)
        .frame(maxHeight: containerLayout == .horizontal ? 200 : 160)
        .background(Color(red: 0.13, green: 0.13, blue: 0.13))
        .cornerRadius(12)
    }
}


#Preview {
    ActiveLearningCard(
        last7DayActivity: ["active", "inactive", "active", "inactive", "active", "inactive", "active"],
        totalActiveDays: 12
    )
    
    .background(Color.black) // makes the card pop in preview
}
