//
//  BolsoBar.swift
//  BolsonaroTweets
//
//  Created by Jared Warren on 7/17/19.
//  Copyright © 2019 Warren. All rights reserved.
//  swiftlint:disable line_length

import UIKit

class BolsoBar: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateTabBarLanguage()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateTabBarLanguage), name: Notification.Name(rawValue: Setting.languageKey), object: nil)
    }
    
    @objc func updateTabBarLanguage() {
        tabBar.items?[0].title = "Tweets"
        tabBar.items?[1].title = "Favorites".localize
        tabBar.items?[2].title = "Settings".localize
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if tabBar.items?.firstIndex(of: item) == 1 {
            print("DONT CRASH")
        }
    }
}
