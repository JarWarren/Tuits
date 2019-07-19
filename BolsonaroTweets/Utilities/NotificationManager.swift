//
//  NotificationManager.swift
//  BolsonaroTweets
//
//  Created by Jared Warren on 7/18/19.
//  Copyright © 2019 Warren. All rights reserved.
//  swiftlint:disable line_length

import Foundation
import UserNotifications

class NotificationManager {
    
    static func scheduleNotification(with subtitle: String) {
        
        guard let url = Bundle.main.url(forResource: "tabBird", withExtension: "png"),
            let attachment = try? UNNotificationAttachment(identifier: "tabBird", url: url, options: nil) else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "One or more new Tweets.".localize
        content.subtitle = subtitle
        content.attachments = [attachment]
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(exactly: 24.0)!, repeats: false)
        
        let request = UNNotificationRequest(identifier: "newTweet", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
}
