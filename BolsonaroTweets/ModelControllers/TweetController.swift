//
//  TweetController.swift
//  BolsonaroTweets
//
//  Created by Jared Warren on 3/1/19.
//  Copyright © 2019 Warren. All rights reserved.
//

import Foundation

class TweetController {

    static let shared = TweetController()
    private init() {}
    
    var timeline: [Tweet]?
    
    func loadTweets() {
        TwitterController.loadTweets { (tweets) in
            guard let tweets = tweets else { return }
            self.timeline = tweets
        }
    }
}
