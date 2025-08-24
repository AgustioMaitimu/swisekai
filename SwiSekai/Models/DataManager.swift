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
            let chapterFiles = chapterURLs.filter { url in
                url.lastPathComponent.hasPrefix("chapter_")
            }
            
            let sortedChapterFiles = chapterFiles.sorted { url1, url2 in
                // Helper function to extract the integer from the filename
                func getChapterNumber(from url: URL) -> Int {
                    let filename = url.lastPathComponent
                    // Removes "chapter_" and ".yaml" to isolate the number
                    let numberString = filename
                        .replacingOccurrences(of: "chapter_", with: "")
                        .replacingOccurrences(of: ".yaml", with: "")
                    // Convert to Int, defaulting to 0 if something goes wrong
                    return Int(numberString) ?? 0
                }
                
                // Compare the two numbers
                return getChapterNumber(from: url1) < getChapterNumber(from: url2)
            }
            
            print("✅ Found \(sortedChapterFiles.count) chapter YAML files (sorted):")
            for url in sortedChapterFiles {
                print("   - \(url.lastPathComponent)")
            }
            
            for url in sortedChapterFiles {
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
