//
//  HomeScreen.swift
//  SwiSekai
//
//  Created by Adrian Yusufa Rachman on 19/08/25.
//

import SwiftUI

struct HomeScreen: View {
    
    enum DayStatus {
        case active
        case inactive
    }
    
    // This will eventually be replaced by data from your database
    @State private var learningActivity: [DayStatus] = [
        .active, .inactive, .active, .inactive, .active, .active, .inactive, .active
    ]
    
    // Computed property to calculate the number of active days
    private var activeDays: Int {
        learningActivity.filter { $0 == .active }.count
    }
    
    var body: some View {
        ScrollView{
            
            Text("Home")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 5)
            
            // Title 2/Emphasized
            Text("Apply your Swift skills by building real-world application")
              .font(
                Font.custom("Inter", size: 17)
                  .weight(.bold)
              )
              .foregroundColor(Color(red: 0.85, green: 0.85, blue: 0.85).opacity(0.6))
              .frame(maxWidth: .infinity, alignment: .leading)
              .padding(.bottom, 35)
            
                

                
          
            
            
            
            Text("For you")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.bottom, 50)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // horizontal 1
            HStack{
                // item 1
                VStack{
                    Text("Item 1")
                }
                // item 2
                VStack{
                    Text("Item 2")
                }
                // item 3
                VStack{
                    Text("Item 3")
                    
                }
              
            }
            .padding(.bottom, 35)
            
            // horizontal 2
            HStack{
                // item 1
                VStack{
                            Text("Total Progress")
                                .font(
                                    Font.custom("SF Pro", size: 20)
                                        .weight(.bold)
                                )
                            
                                .foregroundColor(.white)
                            
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading)
                            
                            Text("You have completed 12 out of 48 modules!")
                                .font(Font.custom("SF Pro", size: 20))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading)
                            
                            
                            HStack{
                                
                                
                                ZStack(alignment: .leading)
                                {
                                    Rectangle()
                                        .fill(.white)
                                        .frame(width: 337, height: 16)
                                        .cornerRadius(10)
                                    Rectangle()
                                        .fill(
                                            LinearGradient(
                                                stops: [
                                                    Gradient.Stop(color: Color(red: 0.99, green: 0.25, blue: 0), location: 0.00),
                                                    Gradient.Stop(color: Color(red: 1, green: 0.49, blue: 0.25), location: 1.00),
                                                ],
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                        .frame(width: 120, height: 16)
                                        .cornerRadius(10)
                                    
                                }
                                Text("25%")
                                  .font(
                                    Font.custom("SF Pro", size: 20)
                                      .weight(.bold)
                                  )
                                  .multilineTextAlignment(.trailing)
                                  .foregroundColor(.white)
                                
                            }.frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading)
                                
                            
                        }
                    .frame(height: 132)
                    .background(Color(red: 0.19, green: 0.2, blue: 0.21))
                    .cornerRadius(8)
                
                
                HStack{
                            VStack{
                                
                                
                                Text("Active Learning")
                                    .font(
                                        Font.custom("SF Pro", size: 20)
                                            .weight(.bold)
                                    )
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading, 16)
                                
                                HStack{
                                    ForEach(learningActivity.indices, id: \.self) { index in
                                        Rectangle()
                                            .fill(learningActivity[index] == .active ?
                                                  LinearGradient(
                                                      stops: [
                                                          Gradient.Stop(color: Color(red: 0.99, green: 0.25, blue: 0), location: 0.00),
                                                          Gradient.Stop(color: Color(red: 1, green: 0.49, blue: 0.25), location: 1.00),
                                                      ],
                                                      startPoint: UnitPoint(x: 0.5, y: 0),
                                                      endPoint: UnitPoint(x: 0.5, y: 1)
                                                  ) : LinearGradient(
                                                    stops: [Gradient.Stop(color: .white, location: 0.00)],
                                                    startPoint: .top,
                                                    endPoint: .bottom
                                                  )
                                            )
                                            .frame(width: 28, height: 28)
                                            .cornerRadius(3)
                                    }
                                    
                                }.frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading, 16)

                            }
                                
                            Text("\(activeDays) Days")
                              .font(
                                Font.custom("SF Pro", size: 38)
                                  .weight(.bold)
                              )
                              .multilineTextAlignment(.trailing)
                              .foregroundColor(.white)
                              .padding(.trailing, 60)
                        }
                    .frame(height: 132)
                    .background(Color(red: 0.19, green: 0.2, blue: 0.21))
                    .cornerRadius(8)
               
               
              
            }
            .padding(.bottom, 35)
            
            Text("Resources")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.bottom, 50)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            //horizontal 3
            HStack{
                VStack{
                          Rectangle()
                              .fill(.gray)
                        
                              .frame(width:356, height:152)
                              
                              .cornerRadius(8)
                              
                          Text("WWDC25")
                            .font(
                              Font.custom("SF Pro", size: 20)
                                .weight(.bold)
                                
                            )
                            .padding(.top,10)
                            .padding(.bottom ,4)
                            .foregroundColor(.white)
                            .frame(maxWidth:.infinity, alignment: .leading)
                            .padding(.leading,15)
                          
                          Text("Access 100+ new videos with sessions,transcripts, docs, and sample code all in one place.")
                            .font(Font.custom("SF Pro", size: 12.29729))
                            .frame(maxWidth:.infinity, alignment: .leading)
                            .foregroundColor(.gray)
                            .padding(.leading,15)
                            .padding(.bottom,4)
                          
                          HStack{
                              Text("􀄔 OPEN")
                                .font(
                                  Font.custom("SF Pro", size: 13.17567)
                                    .weight(.medium)
                                )
                                .foregroundColor(.white)
                          }.frame(width:356, height:42)
                              .background(.blue)
                              .cornerRadius(8)
                         
                          
                          
                      
                          
                      }
                      .frame(width:392, height:336)
                      .background(.black)
              
               
              
            }
            .cornerRadius(8)
            
            
            
        }
        .padding(.horizontal, 40)
        .padding(.vertical, 20)
        .background(Color.mainBackground)
       
        
    }
}

#Preview {
    HomeScreen()
}
