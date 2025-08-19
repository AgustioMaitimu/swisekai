// DataManager.swift

import Foundation
import Yams

class DataManager {
    
    static let shared = DataManager()
    
    var moduleCollection: ModuleCollection
    var projectCollection: ProjectCollection
    var chapterCollection: ChapterCollection
    
    private init() {
        let decoder = YAMLDecoder()
        var allChapters: [Chapter] = []
                
        if let chapterURLs = Bundle.main.urls(forResourcesWithExtension: "yaml", subdirectory: nil) {
            // Filter to only get chapter files (exclude projects.yaml)
            let chapterFiles = chapterURLs.filter { url in
                url.lastPathComponent.hasPrefix("chapter_")
            }
            
            print("✅ Found \(chapterFiles.count) chapter YAML files:")
            for url in chapterFiles {
                print("   - \(url.lastPathComponent)")
            }
            
            for url in chapterFiles {
                do {
                    let yamlString = try String(contentsOf: url, encoding: .utf8)
                    let collectionFromFile = try decoder.decode(ChapterCollection.self, from: yamlString)
                    allChapters.append(contentsOf: collectionFromFile.chapters)
                    
                    print("✅ Successfully loaded \(collectionFromFile.chapters.count) chapter(s) from \(url.lastPathComponent)")

                } catch {
                    print("======================================================")
                    print("🚨 FAILED TO DECODE: \(url.lastPathComponent)")
                    print("🚨 ERROR: \(error)")
                    print("======================================================")
                }
            }
        }
        
        self.chapterCollection = ChapterCollection(chapters: allChapters)
        
        var allModules: [Module] = []
        for chapter in self.chapterCollection.chapters {
            allModules.append(contentsOf: chapter.modules)
        }
        self.moduleCollection = ModuleCollection(modules: allModules)
        
        do {
            guard let url = Bundle.main.url(forResource: "projects", withExtension: "yaml") else {
                fatalError("Could not find projects.yaml in app bundle. Make sure it's added to the target and has the correct name.")
            }
            let yamlString = try String(contentsOf: url, encoding: .utf8)
            self.projectCollection = try decoder.decode(ProjectCollection.self, from: yamlString)
        } catch {
            fatalError("Failed to decode projects.yaml: \(error)")
        }
    }
}
