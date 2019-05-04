//
//  StringExtension.swift
//  BolsonaroTweets
//
//  Created by Jared Warren on 5/4/19.
//  Copyright © 2019 Warren. All rights reserved.
//

import Foundation

extension String {
    
    var asLocalizedDate: String {
        
        var localizedDate = self
        let month = localizedDate.components(separatedBy: " ")[1]
        
        if LocalizationManager.shared.activeLanguage.first == "pt-BR" {
            
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
}
