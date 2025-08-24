//
//  NavigationItem.swift
//  SwiSekai
//
//  Created by Agustio Maitimu on 24/08/25.
//

import Foundation
import SwiftUI

enum NavigationItem: String, CaseIterable, Identifiable {
	case home = "Home"
	case learn = "Learn"
	case projects = "Projects"
	
	var id: String { rawValue }
	
	var systemImage: String {
		switch self {
		case .home: return "square.grid.2x2"
		case .learn: return "book"
		case .projects: return "bolt.horizontal"
		}
	}
}

final class NavigationStore: ObservableObject {
	@Published var homePath = NavigationPath()
	@Published var learnPath = NavigationPath()
	@Published var projectsPath = NavigationPath()
	
	func reset(_ item: NavigationItem) {
		switch item {
		case .home:
			if homePath.count > 0 { homePath.removeLast(homePath.count) }
		case .learn:
			if learnPath.count > 0 { learnPath.removeLast(learnPath.count) }
		case .projects:
			if projectsPath.count > 0 { projectsPath.removeLast(projectsPath.count) }
		}
	}
}
