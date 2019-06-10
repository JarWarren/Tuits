//
//  Tweet.swift
//  BolsonaroTweets
//
//  Created by Jared Warren on 3/1/19.
//  Copyright © 2019 Warren. All rights reserved.
//  swiftlint:disable identifier_name line_length cyclomatic_complexity

import Foundation

class Tweet {
    
    var type: TweetType
    let date: String
    let handle: String
    let name: String
    let text: String
    let id: Int
    let profilePicURL: String
    var quote: QuoteTweet?
    var mediaType: String?
    var mediaURLs = [String]()
    
    init(tweetType: TweetType, date: String, handle: String, name: String, text: String, id: Int, profilePicURL: String) {
        
        self.type = tweetType
        self.date = date
        self.handle = handle
        self.name = name
        self.text = text
        self.id = id
        self.profilePicURL = profilePicURL
    }
    
    convenience init?(tuit: Tuit) {
        
        // 1 - is retweeted?
        switch tuit.retweeted_status == nil {
        case true:
            
            guard let date = tuit.created_at?.prefix(16),
                let handle = tuit.user?.screen_name,
                let name = tuit.user?.name,
                let text = tuit.full_text,
                let profilePicURL = tuit.user?.profile_image_url_https else { return nil }
            let id = tuit.id
            
            self.init(tweetType: .original, date: String(date), handle: handle, name: name, text: text, id: id, profilePicURL: profilePicURL)
            
        case false:
            guard let date = tuit.retweeted_status?.created_at?.prefix(16),
                let handle = tuit.retweeted_status?.user?.screen_name,
                let name = tuit.retweeted_status?.user?.name,
                let text = tuit.retweeted_status?.full_text,
                let profilePicURL = tuit.retweeted_status?.user?.profile_image_url_https else { return nil }
            let id = tuit.id
            
            self.init(tweetType: .retweet, date: String(date), handle: handle, name: name, text: text, id: id, profilePicURL: profilePicURL)
        }
        
        // 2- determine if it quotes
        if tuit.quoted_status != nil {
            guard let qText = tuit.quoted_status?.full_text,
                let qDate = tuit.quoted_status?.created_at?.prefix(16),
                let qName = tuit.quoted_status?.user?.name,
                let qHandle = tuit.quoted_status?.user?.screen_name,
                let qProfPic = tuit.quoted_status?.user?.profile_image_url_https else { return }
            let quote = QuoteTweet(text: qText, date: String(qDate), name: qName, handle: qHandle, imageURL: qProfPic)
            self.type = .quote
            self.quote = quote
        }
        
        // 3 - determine if there is media
        guard let mediaType = tuit.extended_entities?.media?.first?.type,
            let media = tuit.extended_entities?.media else { return }
        self.mediaType = mediaType
        
        // 4 - determine media type
        switch mediaType {
            
        // photo
        case "photo":
            for medium in media {
                mediaURLs.append(medium.media_url_https ?? "")
            }
            
        case nil: return // no media (this should never be called)
            
        // video or animated_gif
        default:
            for medium in media {
                mediaURLs.append(medium.video_info?.variants?.first?.url ?? "")
            }
        }
        
    }
}

struct QuoteTweet {
    
    let text: String?
    let date: String?
    let name: String?
    let handle: String?
    let imageURL: String?
}

enum TweetType {
    
    case original
    case reply
    case retweet
    case quote
}
