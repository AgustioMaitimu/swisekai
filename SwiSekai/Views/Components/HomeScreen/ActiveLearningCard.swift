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
        HStack {
            VStack(alignment: .leading){
                Text("Past 7 Days")
                    .font(
                        Font.custom("SF Pro", size: 20)
                            .weight(.bold)
                    )
                
                    .foregroundColor(.white)
                    .padding(.bottom, 13)
                
                HStack{
                    ForEach(last7DayActivity.indices, id: \.self) { index in
                        VStack {
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
                                            .stroke(Color.gray, lineWidth: 3)
                                    )
                                
                            }
                            
                            // Day label
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
            
            VStack(alignment: .trailing) {
                Text("Total Learning")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)

                Text("\(totalActiveDays) Days")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity, alignment: .trailing) // push VStack to right side
            .padding(.horizontal, 40)

        }
        .padding()
        //        .frame(minHeight: 132)
        .frame(
            //                    minWidth: containerLayout == .horizontal ? 500 : 100,
            //                    maxWidth: containerLayout == .horizontal ? .infinity: 800,
            maxHeight: 200
        )
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
