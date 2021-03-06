//
//  StringExtension.swift
//  BolsonaroTweets
//
//  Created by Jared Warren on 5/4/19.
//  Copyright © 2019 Warren. All rights reserved.
//

import UIKit

extension String {
    
    var asLocalizedDate: String {
        
        var localizedDate = self
        let month = localizedDate.components(separatedBy: " ")[1]
        
        if SettingsManager.currentLanguage() == "pt-BR" {
            
            switch prefix(3) {
            case "Sun":
                localizedDate = localizedDate.replacingOccurrences(of: "Sun", with: "Dom")
            case "Mon":
                localizedDate = localizedDate.replacingOccurrences(of: "Mon", with: "Seg")
            case "Tue":
                localizedDate = localizedDate.replacingOccurrences(of: "Tue", with: "Ter")
            case "Wed":
                localizedDate = localizedDate.replacingOccurrences(of: "Wed", with: "Qua")
            case "Thu":
                localizedDate = localizedDate.replacingOccurrences(of: "Thu", with: "Qui")
            case "Fri":
                localizedDate = localizedDate.replacingOccurrences(of: "Fri", with: "Sex")
            case "Sat":
                localizedDate = localizedDate.replacingOccurrences(of: "Sat", with: "Sab")
            default: return self
            }
            switch month {
            case "Feb":
                localizedDate = localizedDate.replacingOccurrences(of: "Feb", with: "Fev")
            case "Apr":
                localizedDate = localizedDate.replacingOccurrences(of: "Apr", with: "Abr")
            case "May":
                localizedDate = localizedDate.replacingOccurrences(of: "May", with: "Mai")
            case "Aug":
                localizedDate = localizedDate.replacingOccurrences(of: "Aug", with: "Ago")
            case "Sep":
                localizedDate = localizedDate.replacingOccurrences(of: "Sep", with: "Set")
            case "Oct":
                localizedDate = localizedDate.replacingOccurrences(of: "Oct", with: "Out")
            case "Dec":
                localizedDate = localizedDate.replacingOccurrences(of: "Dec", with: "Dez")
            default: return localizedDate
            }
        }
        return localizedDate
    }
    
    var tweetFormatted: NSMutableAttributedString {
        
        var newSelf = self
        
        let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        var range = NSRange(location: 0, length: newSelf.utf16.count)
        
        if let matches = detector?.matches(in: newSelf, options: [], range: range) {
            
            for match in matches {
                guard let range = Range(match.range, in: newSelf) else { continue }
                let url = newSelf[range]
                newSelf = newSelf.replacingOccurrences(of: url, with: "")
            }
        }
        
        let searchPattern = "(^|[^@\\w])@(\\w{1,15})\\b"
        
        let attributed = NSMutableAttributedString(string: newSelf)
        
        let regex = try? NSRegularExpression(pattern: searchPattern, options: [.caseInsensitive])
        
        range = NSRange(location: 0, length: attributed.string.utf16.count)
        
        for match in regex?.matches(in: attributed.string, options: [], range: range) ?? [] {
            attributed.addAttribute(.foregroundColor, value: #colorLiteral(red: 0.03756484017, green: 0.5855799317, blue: 0.06929770857, alpha: 1), range: match.range)
        }
        
        let secondRegex = try? NSRegularExpression(pattern: "#[a-z0-9]+", options: .caseInsensitive)
        
        for match in secondRegex?.matches(in: attributed.string, options: [], range: range) ?? [] {
            attributed.addAttribute(.foregroundColor, value: #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1), range: match.range)
        }
        
        return attributed
    }
    
    var localize: String {
        let path = Bundle.main.path(forResource: SettingsManager.currentLanguage(), ofType: "lproj")
        let localizedBundle = Bundle(path: path ?? Bundle.main.path(forResource: "en", ofType: "lproj")!)
        return NSLocalizedString(self, tableName: nil, bundle: localizedBundle!, value: "", comment: "")
    }
}
