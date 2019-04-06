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
    
    convenience init?(tuit: Tuit) {
        
        guard let date = tuit.created_at?.prefix(16),
            let handle = tuit.user?.screen_name,
            let name = tuit.user?.name,
            let text = tuit.full_text else { return nil }
        
        self.init(date: String(date), handle: handle, name: name, text: text)
    }
}
