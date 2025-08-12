//
//  DataManager.swift
//  SwiSekai
//
//  Created by Agustio Maitimu on 12/08/25.
//

import Foundation
import Yams

class DataManager {
	
	static let shared = DataManager()
	
	var moduleCollection: ModuleCollection
	var projectCollection: ProjectCollection
	
	private init() {
		let decoder = YAMLDecoder()
		
		do {
			guard let url = Bundle.main.url(forResource: "modules", withExtension: "yaml") else {
				fatalError("Could not find modules.yaml in app bundle.")
			}
			let yamlString = try String(contentsOf: url, encoding: .utf8)
			self.moduleCollection = try decoder.decode(ModuleCollection.self, from: yamlString)
		} catch {
			fatalError("Failed to decode modules.yaml: \(error)")
		}
		
		do {
			guard let url = Bundle.main.url(forResource: "projects", withExtension: "yaml") else {
				fatalError("Could not find projects.yaml in app bundle.")
			}
			let yamlString = try String(contentsOf: url, encoding: .utf8)
			self.projectCollection = try decoder.decode(ProjectCollection.self, from: yamlString)
		} catch {
			fatalError("Failed to decode projects.yaml: \(error)")
		}
	}
}
