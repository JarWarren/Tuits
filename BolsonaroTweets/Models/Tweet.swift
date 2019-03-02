//
//  Tweet.swift
//  BolsonaroTweets
//
//  Created by Jared Warren on 3/1/19.
//  Copyright © 2019 Warren. All rights reserved.
//

import Foundation

class Tweet {
    
    let date: String
    let handle: String
    let name: String
    let text: String
    
    init(date: String, handle: String, name: String, text: String) {
        
        self.date = date
        self.handle = handle
        self.name = name
        self.text = text
    }
}
