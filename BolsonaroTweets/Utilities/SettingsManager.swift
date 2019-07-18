//
//  SettingsManager.swift
//  BolsonaroTweets
//
//  Created by Jared Warren on 5/4/19.
//  Copyright © 2019 Warren. All rights reserved.
//  swiftlint:disable line_length

import Foundation

class SettingsManager {
    
    /// Change the language and post an app-wide notification.
    static func changeLanguage(to language: Setting.Language) {
        UserDefaults.standard.setValue(language.value, forKey: language.key)
        NotificationCenter.default.post(name: Notification.Name(language.key), object: nil)
    }
    
    /// Toggle one of the bool settings.
    static func updateToggleSetting(_ setting: Setting.Toggle, to value: Bool) {
        UserDefaults.standard.setValue(value, forKey: setting.key)
        NotificationCenter.default.post(name: Notification.Name(Setting.toggleKey), object: nil)
    }
    
    /// Retrieve the current language in the form of a string. Should be called when VCs first load.
    static func currentLanguage() -> String {
        return UserDefaults.standard.string(forKey: Setting.languageKey) ?? "pt-BR"
    }
    
    /// Retrieve the toggle setting values. Used when composing the url parameters. Returned in the same order they're passed in.
    static func valuesForToggleSettings(_ settings: [Setting.Toggle]) -> [Bool] {
        return settings.map { $0.value }
    }
}

enum Setting {
    
    case language(Language)
    case toggle(Toggle)
    
    /// language
    static var languageKey = "language"
    /// toggle
    static var toggleKey = "toggle"
    /// language or toggle
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
        
        /// `"language"`.
        var key: String { return "language" }
    }
    
    // TOGGLE
    enum Toggle: String {
        
        case replies
        case retweets
        
        /// Saved bool setting. `False` if not yet set.
        var value: Bool { return UserDefaults.standard.bool(forKey: key) }
        /// "replies" or "retweets"
        var key: String { return self.rawValue }
        }
    
}
