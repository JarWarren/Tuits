//
//  SettingsManager.swift
//  BolsonaroTweets
//
//  Created by Jared Warren on 5/4/19.
//  Copyright © 2019 Warren. All rights reserved.
//  swiftlint:disable line_length

import Foundation

class SettingsManager {
    
    // successfully merged localizationmanager and settingscontroller into one. got rid of singleton and reduced code by hundreds of lines. now saves to user defaults. after saving, posts a notification named "language", "retweets", etc. need to add an observer on view controllers https://www.hackingwithswift.com/example-code/system/how-to-post-messages-using-notificationcenter
    
    /// Change the language and post an app-wide notification.
    static func changeLanguage(to language: Setting.Language) {
        UserDefaults.standard.setValue(language.value, forKey: language.key)
        NotificationCenter.default.post(name: Notification.Name(language.key), object: nil)
    }
    
    /// Toggle one of the bool settings.
    static func updateSetting(_ setting: Setting.Toggle, to value: Bool) {
        UserDefaults.standard.setValue(value, forKey: setting.key)
        NotificationCenter.default.post(name: Notification.Name(Setting.toggleKey), object: nil)
    }
    
    /// Retrieve the current language in the form of a string. Should be called when VCs first load.
    static func currentLanguage() -> String {
        return UserDefaults.standard.string(forKey: Setting.languageKey) ?? "pt-BR"
    }
    
    /// Retrieve the toggle setting values. Used when composing the url parameters. Returned in the same order they're passed in.
    static func valuesForSettings(_ settings: [Setting.Toggle]) -> [Bool] {
        return settings.map { $0.value }
    }
}

enum Setting {
    
    case language(Language)
    case toggle(Toggle)
    
    // KEY AND VALUE
    static var languageKey = "language"
    static var toggleKey = "toggle"
    var key: String {
        switch self {
        case .language:
            return "language"
        case .toggle:
            return "toggle"
        }
    }
    
    // LANGUAGE
    enum Language {
        
        case english
        case portuguese
        
        /// "en" or "pt-BR"
        var value: String {
            switch self {
            case .english:
                return "en"
            case .portuguese:
                return "pt-BR"
            }
        }
        
        /// Returns `"language"`.
        var key: String { return "language" }
    }
    
    // TOGGLE
    enum Toggle: String {
        
        case replies
        case retweets
        
        /// Saved bool value for setting. Returns `false` if nothing has been set.
        var value: Bool { return UserDefaults.standard.bool(forKey: key) }
        /// String name of the toggle setting.
        var key: String { return self.rawValue }
        }
    
}
