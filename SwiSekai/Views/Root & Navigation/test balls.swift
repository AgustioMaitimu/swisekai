//
//  test balls.swift
//  SwiSekai
//
//  Created by Adrian Yusufa Rachman on 14/08/25.
//

import SwiftUI

struct test_balls: View {
	@State var selection: NavigationItem = .home
	
	private let widthThreshold: CGFloat = 900
	
	var body: some View {
//				GeometryReader { geo in
//					if geo.size.width > widthThreshold {
//						SideBarView(selection: $selection)
//							.onAppear()
//					} else {
//						TabBarView(selection: $selection)
//							.scrollContentBackground(.hidden)
//					}
//				}
//				.background(.mainBackground)
		
		
		NavigationView(selection: $selection)
	}
}
