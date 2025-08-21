//
//  HomeScreen.swift
//  SwiSekai
//
//  Created by Adrian Yusufa Rachman on 19/08/25.
//

import SwiftUI
import SwiftData

struct HomeScreen: View {
	
	// --- Data for Total Progress ---
	@Environment(\.modelContext) private var modelContext
	@Query private var userDataItems: [UserData]
	private var userData: UserData { userDataItems.first ?? UserData.shared(in: modelContext) }
	private var modules = DataManager.shared.moduleCollection.modules
	
	private var completedModules: Int {
		userData.currentLevel
	}
	
	private var totalModules: Int {
		modules.count
	}
	
	// A computed property that returns only the last 7 days for display.
	private var recentActivity: [String] {
		userData.last7DayActivity
	}
	
	// This still calculates the total from the *entire* activity list.
	private var activeDays: Int {
		userData.totalActiveDays
	}
	
	// --- Computed Properties for Progress ---
	private var progress: Double {
		guard totalModules > 0 else {
			return 0.0 // Return 0 if there are no modules to complete.
		}
		return Double(completedModules) / Double(totalModules)
	}
	
	private var progressSubtitle: String {
		return "You have completed \(completedModules) out of \(totalModules) modules!"
	}
	
	private var progressPercentageText: String {
		return "\(Int(progress * 100))%"
	}
	
	// Define columns for the responsive grid
	private let columns = [GridItem(.adaptive(minimum: 350))]
	
	var body: some View {
		GeometryReader { geometry in
            VStack {
                ScrollView (showsIndicators: false){
                    
                    Text("Home")
                        .font(.largeTitle)
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
                        .padding(.bottom, 20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    
                    HStack  {
                        // card thingy
                        VStack(alignment: .leading) {
                            
                            HStack{
                                VStack{
                                    Text("Chapter 1")
                                        .font(
                                            Font.custom("SF Pro", size: 20)
                                                .weight(.bold)
                                        )
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    Text("Swift Data Types")
                                        .font(
                                            Font.custom("SF Pro", size: 48)
                                                .weight(.bold)
                                        )
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    Text("Variables & String")
                                        .font(
                                            Font.custom("SF Pro", size: 32)
                                                .weight(.medium)
                                        )
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    
                                }
                                Image("logoswift")
                                    .resizable()
                                    .frame(width: 148, height: 148)
                            }.padding(.bottom, 40)
                            
                            
                            
                            HStack{
                                Text("Continue")
                                    .font(
                                        Font.custom("SF Pro", size: 20)
                                            .weight(.medium)
                                    )
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.white)
                                
                                    .frame(width: 150, height: 54)
                                
                                    .background(Color.blue)
                                    .cornerRadius(40)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                            
                        } .padding(30)
                            .frame(width: 641, height: 328)
                            .background(
                                LinearGradient(
                                    stops: [
                                        Gradient.Stop(color: Color(red: 0.98, green: 0.63, blue: 0.25), location: 0.00),
                                        Gradient.Stop(color: Color(red: 0.94, green: 0.27, blue: 0.2), location: 1.00),
                                    ],
                                    startPoint: UnitPoint(x: 0.5, y: 0),
                                    endPoint: UnitPoint(x: 0.5, y: 1)
                                )
                            )
                            .cornerRadius(20)
                        
                        //projetcs
                        VStack{
                            
                            VStack{
                                Text("Projects")
                                    .font(
                                        Font.custom("SF Pro", size: 20)
                                            .weight(.bold)
                                    )
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading, 30)
                                
                            }
                            VStack(spacing: 16){
                                HStack{
                                    Text("Calculator")
                                        .font(
                                            Font.custom("SF Pro", size: 20)
                                                .weight(.medium))
                                        .foregroundStyle(.black)
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.black)
                                        .padding(.trailing, 10)
                                }.padding()
                                    .frame(width: 314,height: 42, alignment: .leading)
                                    .background(Color(red: 0.91, green: 0.91, blue: 0.91))
                                    .cornerRadius(100)
                                
                                
                                HStack{
                                    Text("Algebra Abacus")
                                        .font(
                                            Font.custom("SF Pro", size: 20)
                                                .weight(.medium))
                                        .foregroundStyle(.black)
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.black)
                                        .padding(.trailing, 10)
                                }.padding()
                                    .frame(width: 314,height: 42, alignment: .leading)
                                    .background(Color(red: 0.91, green: 0.91, blue: 0.91))
                                    .cornerRadius(100)
                                
                                HStack{
                                    Text("J Word Pass")
                                        .font(
                                            Font.custom("SF Pro", size: 20)
                                                .weight(.medium))
                                        .foregroundStyle(.black)
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.black)
                                        .padding(.trailing, 10)
                                }.padding()
                                    .frame(width: 314,height: 42, alignment: .leading)
                                    .background(Color(red: 0.91, green: 0.91, blue: 0.91))
                                    .cornerRadius(100)
                                
                            }.padding(.bottom, 30)
                            HStack(spacing:40 ){
                                Text("25%")
                                    .font(Font.custom("SF Pro", size: 16))
                                    .foregroundColor(.white)
                                    .frame(maxWidth:.infinity, alignment: .leading)
                                    .padding(.leading, 10)
                                
                                Text("12/48")
                                    .font(Font.custom("SF Pro", size: 18))
                                    .foregroundColor(.white)
                                    .frame(maxWidth:.infinity, alignment: .leading)
                                
                                Text("All projects")
                                    .font(
                                        Font.custom("SF Pro", size: 20)
                                            .weight(.medium)
                                    )
                                    .foregroundColor(.white)
                                    .frame(width: 170, height: 54)
                                    .background(Color(red: 0.04, green: 0.52, blue: 1))
                                    .cornerRadius(100)
                                
                                
                            }.frame(width: 314)
                            
                            
                            
                        }
                        .frame(width:364, height: 328)
                        
                        
                        
                        
                        
                    }
                    .padding(.bottom, 50)
                    
                    Text("Progress")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.bottom, 20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Adaptive grid for "For you" cards
                    LazyVGrid(columns: columns, alignment: .center, spacing: 20) {
                        progressCard()
                        activeLearningCard()
                    }
                    .padding(.bottom, 35)
                    
                    
                    Text("Resources")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.bottom, 20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Adaptive grid for "Resources" cards
                    let rows = [
                        GridItem()
                    ]
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHGrid(rows: rows, spacing: 50) {
                            resourceCard()
                            resourceCard()
                            resourceCard()
                            resourceCard()
                            // Add more resourceCard() here
                        }
                        .padding()
                    }
                    
                    
                }
               
            }
            .padding(.horizontal, 100)
            .padding(.vertical, 20)
            .background(Color.mainBackground)
            
          
            
		}
	}
	
	func progressCard() -> some View {
		VStack(alignment: .leading){
			Text("Total Progress")
				.font(.title3.weight(.bold))
				.foregroundColor(.white)
			
			Text(progressSubtitle)
				.font(.title3)
				.foregroundColor(.white.opacity(0.8))
				.padding(.top, 1)
				.fixedSize(horizontal: false, vertical: true)
			
			Spacer()
			
			HStack{
				GeometryReader { geo in
					ZStack(alignment: .leading) {
						Rectangle()
							.fill(.white)
							.frame(height: 16)
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
							.frame(width: geo.size.width * CGFloat(progress), height: 16)
							.cornerRadius(10)
					}
				}
				
				Text(progressPercentageText)
					.font(.title2.weight(.bold))
					.multilineTextAlignment(.trailing)
					.foregroundColor(.white)
			}
			.frame(height: 16)
		}
		.padding()
		.frame(minHeight: 132)
		.background(Color(red: 0.19, green: 0.2, blue: 0.21))
		.cornerRadius(12)
	}
	
	func activeLearningCard() -> some View {
		HStack {
			VStack(alignment: .leading){
				Text("Active Learning")
					.font(.title3.weight(.bold))
					.foregroundColor(.white)
					.padding(.bottom, 20)
				
				
				
				HStack{
					ForEach(recentActivity.indices, id: \.self) { index in
						Rectangle()
							.fill(recentActivity[index] == "active" ? // Changed from .active to "active"
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
							.aspectRatio(1, contentMode: .fit)
							.cornerRadius(4)
					}
				}
			}
			
			
			
			VStack {
				
				Text("\(activeDays) Days")
					.font(.system(size: 38, weight: .bold,))
					.multilineTextAlignment(.trailing)
					.foregroundColor(.white)
					.padding(.horizontal, 40)
				
			}
		}
		.padding()
		.frame(minHeight: 132)
		.background(Color(red: 0.19, green: 0.2, blue: 0.21))
		.cornerRadius(12)
	}
	
	func resourceCard() -> some View {
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


#Preview {
    HomeScreen()
}
