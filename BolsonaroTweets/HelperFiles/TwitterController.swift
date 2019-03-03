//
//  TwitterController.swift
//  BolsonaroTweets
//
//  Created by Jared Warren on 3/1/19.
//  Copyright © 2019 Warren. All rights reserved.
//

import Foundation

class TwitterController {
    
    static func loadTweets(completion: @escaping ([Tweet]?) -> Void) {
        
        if let path = Bundle.main.path(forResource: "sample", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONDecoder().decode([Tuit].self, from: data)
                var tweets = [Tweet]()
                for tuit in jsonResult {
                    guard let date = tuit.created_at?.prefix(16),
                        let handle = tuit.user?.screen_name,
                        let name = tuit.user?.name,
                        let text = tuit.text else { completion(nil); return }
                    let tweet = Tweet(date: String(date), handle: handle, name: name, text: text)
                    tweets.append(tweet)
                }
                guard tweets.isEmpty == false else { completion(nil); return }
                completion(tweets)
                return
            } catch {
                completion(nil)
                return
            }
        }
    }
    
    static func fetchTweets(completion: @escaping ([Tweet]?) -> Void) {
        
        guard let baseURL = URL(string: "https://api.twitter.com/1.1/statuses/user_timeline.json?screen_name=jairbolsonaro&count=10") else { return }
        
        var request = URLRequest(url: baseURL)
        request.addValue("o2p62kIvNKnf8qgo4UKUq3Jim", forHTTPHeaderField: "oauth_consumer_key")
    }
}

// https://developer.twitter.com/en/docs/basics/authentication/overview/application-only
