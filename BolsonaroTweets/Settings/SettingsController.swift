//
//  SettingsController.swift
//  BolsonaroTweets
//
//  Created by Jared Warren on 5/4/19.
//  Copyright © 2019 Warren. All rights reserved.
//  swiftlint:disable line_length

import Foundation

class SettingsController {
    
    static let shared = SettingsController()
    var allSettings: [String: Bool] = {
        if let settings = loadSettings() {
            return settings
        } else {
            return ["Retweets": false]
        }
    }()
    
    func shouldIncludeRetweets(bool: Bool) {
        allSettings["Retweets"] = bool
        saveSettings()
    }
    
    fileprivate func saveSettings() {
        do {
            let savedSettings = try JSONEncoder().encode(allSettings)
            try savedSettings.write(to: fileURL())
        } catch {
            print("\(error) \(error.localizedDescription)")
        }
    }
    
    fileprivate static func loadSettings() -> [String: Bool]? {
        guard let decodedSettings = try? JSONDecoder().decode([String: Bool].self, from: Data(contentsOf: fileURL())) else { return nil }
            return decodedSettings
    }
    
    fileprivate static func fileURL() -> URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileName = "Settings"
        let documentsDirectoryURL = urls[0].appendingPathComponent(fileName)
        return documentsDirectoryURL
    }
    
    fileprivate func fileURL() -> URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileName = "Settings"
        let documentsDirectoryURL = urls[0].appendingPathComponent(fileName)
        return documentsDirectoryURL
    }
}
