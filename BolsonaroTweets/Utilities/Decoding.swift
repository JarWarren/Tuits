//
//  Decoding.swift
//  BolsonaroTweets
//
//  Created by Jared Warren on 3/1/19.
//  Copyright © 2019 Warren. All rights reserved.
//  swiftlint:disable identifier_name

import Foundation

struct Tuit: Decodable {
    
    let full_text: String?
    let created_at: String?
    let user: User?
    let id: Int
}

struct User: Decodable {
    
    let name: String?
    let screen_name: String?
}
