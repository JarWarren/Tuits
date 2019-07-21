//
//  Decoding.swift
//  BolsonaroTweets
//
//  Created by Jared Warren on 3/1/19.
//  Copyright © 2019 Warren. All rights reserved.
//  swiftlint:disable identifier_name

import Foundation

// MAIN TWEET
struct TweetObject: Decodable {
    let full_text: String?
    let created_at: String?
    let user: User?
    let id: Int
    let retweeted: Bool
    let retweeted_status: Retuit?
    let quoted_status: Quote?
    let extended_entities: Entity?
}

// MEDIA
struct Entity: Decodable {
    let media: [Medium]?
}

// if the media type is "photo", then the desired url is media_url_https
struct Medium: Decodable {
    let type: String?
    let media_url_https: String?
    let video_info: VideoInfo?
}

struct VideoInfo: Decodable {
    let variants: [VideoVariant]?
}
// if the media type is NOT "photo", then the desired url is the variant url
struct VideoVariant: Decodable {
    let url: String?
}

// USER
struct User: Decodable {
    let name: String?
    let screen_name: String?
    let profile_image_url_https: String?
}

// RETWEET
struct Retuit: Decodable {
    let full_text: String?
    let created_at: String?
    let user: User?
    let extended_entities: Entity?
}

// QUOTE
struct Quote: Decodable {
    let full_text: String?
    let created_at: String?
    let user: User?
}
