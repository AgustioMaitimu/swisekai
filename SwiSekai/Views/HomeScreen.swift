//
//  HomeScreen.swift
//  SwiSekai
//
//  Created by Adrian Yusufa Rachman on 19/08/25.
//

import SwiftUI

struct HomeScreen: View {
    var body: some View {
        ScrollView{
            
            Text("Home")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.bottom, 50)
                .frame(maxWidth: .infinity, alignment: .leading) // 👈 makes it start from the left
                

                
          
            
            
            
            
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
            
            // horizontal 2
            HStack{
                // item 1
                VStack{
                    Text("Item 1")
                }
               
               
              
            }
            
            //horizontal 3
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
            
            
            
        }
        .padding(.horizontal, 40)
        .padding(.vertical, 20)
        .background(Color.mainBackground)
       
        
    }
}

#Preview {
    HomeScreen()
}
