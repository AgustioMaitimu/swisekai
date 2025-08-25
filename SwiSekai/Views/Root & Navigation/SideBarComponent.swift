//
//  SideBarComponent.swift
//  SwiSekai
//
//  Created by Agustio Maitimu on 25/08/25.
//

import SwiftUI

struct SideBarComponent: View {
	@Binding var selection: NavigationItem
	@ObservedObject private var nav = NavigationStore()
	
	var body: some View {
		VStack(alignment: .leading, spacing: 0) {
			HStack(alignment: .center, spacing: 8) {
				VStack(spacing: -4) {
					Text("スイ")
						.font(.title)
					Text("せかい")
				}
				Text("SwiSekai")
					.font(.title.bold())
			}
			.foregroundStyle(.white)
			.padding(.horizontal, 20)
			.padding(.top, 60)
			.padding(.bottom, 32)
			
			Text("Main")
				.font(.caption)
				.opacity(0.4)
				.padding(.leading, 14)
				.padding(.bottom, 7)
			
			List(NavigationItem.allCases, id: \.self, selection: $selection) { item in
				let isSelected = selection == item
				HStack {
					Label(item.rawValue, systemImage: item.systemImage)
					Spacer(minLength: 0)
				}
				.listRowBackground(Color.projectsButtonOff)
				.foregroundStyle(isSelected ? .black : .white)
				.padding(.vertical, 14)
				.padding(.leading, 18)
				.background(isSelected ? .white : .clear)
				.clipShape(.rect(cornerRadius: 8))
				.onTapGesture {
					selection = item
					nav.reset(item)
				}
				.listRowSeparator(.hidden)
			}
			.listStyle(.plain)
			.scrollContentBackground(.hidden)
		}
		.padding(.horizontal, 12)
		.frame(width: 250)
		.background(.projectsButtonOff)
		.clipShape(
			UnevenRoundedRectangle(bottomTrailingRadius: 28, topTrailingRadius: 28)
		)
		.shadow(color: .black.opacity(0.15), radius: 8, x: 4, y: 0)
	}
}

//#Preview {
//    SideBarComponent()
//}
