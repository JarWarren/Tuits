//
//  Tweet.swift
//  BolsonaroTweets
//
//  Created by Jared Warren on 3/1/19.
//  Copyright © 2019 Warren. All rights reserved.
//  swiftlint:disable identifier_name

import Foundation

class Tweet {
    
    let date: String
    let handle: String
    let name: String
    let text: String
    let id: Int
    let profilePicURL: String
    var mediaType: String?
    var mediaURLs: [String]?
    
    init(date: String, handle: String, name: String, text: String, id: Int, profilePicURL: String) {
        
        self.date = date
        self.handle = handle
        self.name = name
        self.text = text
        self.id = id
        self.profilePicURL = profilePicURL
    }
    
    convenience init?(tuit: Tuit) {
        
        // 1 - base tweet
        guard let date = tuit.created_at?.prefix(16),
            let handle = tuit.user?.screen_name,
            let name = tuit.user?.name,
            let text = tuit.full_text,
            let profilePicURL = tuit.user?.profile_image_url_https else { return nil }
        let id = tuit.id
        
        self.init(date: String(date), handle: handle, name: name, text: text, id: id, profilePicURL: profilePicURL)
        
        // 2 - determine if there is media
        if let mediaType = tuit.extended_entities?.media?.first?.type {
            self.mediaType = mediaType
        }
        
        // 3 - determine media type
        guard let media = tuit.extended_entities?.media else { return }
        var mediaURLs = [String]()
        
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
