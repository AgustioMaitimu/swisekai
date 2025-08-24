//
//  UserMessageView.swift
//  SwiSekai
//
//  Created by Ryan Hangralim on 24/08/25.
//

import SwiftUI

struct UserMessageView: View {
    let text: String
    
    var body: some View {
        HStack{
            Spacer()
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    Text("You")
                        .fontWeight(.semibold)
                    
                    Text("08.58")
                }
                .font(.caption)
                .foregroundColor(.secondary)
                
                Text(text)
                    .foregroundColor(.primary)
            }
            
            .padding()
            .background(Color("UserMessageColor"))
            .cornerRadius(12)
            .frame(maxWidth: 400, alignment: .leading)
        }
    }
}

#Preview {
    UserMessageView(text: "This is a test message")
}
