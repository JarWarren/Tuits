//
//  LocalizationManager.swift
//  BolsonaroTweets
//
//  Created by Jared Warren on 4/6/19.
//  Copyright © 2019 Warren. All rights reserved.
//

import Foundation

class LocalizationManager {
    
    static let shared = LocalizationManager()
    private init() {}
    
    var activeLanguage: [String] = {
        let language = NSLocale.preferredLanguages
        
        switch true {
            
        case language.first?.prefix(2) == "pt" :
            return ["pt-BR"]
            
        default:
            return ["\(String(describing: NSLocale.preferredLanguages.first))"]
            
        }
    }()
    
    func setToEnglish() {
        LocalizationManager.shared.activeLanguage = ["en"]
        print("🇺🇸")
    }
    
    func definirParaOPortuguês() {
        LocalizationManager.shared.activeLanguage = ["pt-BR"]
        print("🇧🇷")
    }
    
    func saveLanguage() {
        do {
            let savedLanguage = try JSONEncoder().encode(self.activeLanguage)
            try savedLanguage.write(to: fileURL())
        } catch {
            print("\(error) \(error.localizedDescription)")
        }
    }
    
    func loadLanguage() {
        do {
            let decodedLanguage = try JSONDecoder().decode([String].self, from: Data(contentsOf: fileURL()))
            self.activeLanguage = decodedLanguage
        } catch {
            print("Language set to English.")
        }
    }
    
    private func fileURL() -> URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileName = "ActiveLanguage.json"
        let documentsDirectoryURL = urls[0].appendingPathComponent(fileName)
        return documentsDirectoryURL
    }
}

public extension String {
    
    var localize: String {
        LocalizationManager.shared.loadLanguage()
        let path = Bundle.main.path(forResource: LocalizationManager.shared.activeLanguage[0], ofType: "lproj")
        let localizedBundle = Bundle(path: path ?? Bundle.main.path(forResource: "en", ofType: "lproj")!)
        return NSLocalizedString(self, tableName: nil, bundle: localizedBundle!, value: "", comment: "")
    }
}
