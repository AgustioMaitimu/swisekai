//
//  test balls.swift
//  SwiSekai
//
//  Created by Adrian Yusufa Rachman on 14/08/25.
//

import SwiftUI

struct test_balls: View {
    @State var selection: NavigationItem = .home
    private let widthThreshold: CGFloat = 600

    var body: some View {
        GeometryReader { geo in
            if geo.size.width > widthThreshold {
                SideBarView(selection: $selection)
            } else {
                TabBarView(selection: $selection)
					.scrollContentBackground(.hidden)
            }
        }
    }
}


#Preview {
    test_balls()
}
