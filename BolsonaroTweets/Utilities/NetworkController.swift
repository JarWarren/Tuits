//
//  NetworkController.swift
//  BolsonaroTweets
//
//  Created by Jared Warren on 7/23/19.
//  Copyright © 2019 Warren. All rights reserved.
//  swiftlint:disable line_length

import UIKit

enum NetworkController: NetworkManager {
    
    static func fetchTweets(_ count: Int, completion: @escaping (Result <[Tweet], Error>) -> Void) {
        let querySettings = SettingsManager.valuesForToggleSettings([.retweets, .replies])
        guard let url = URL(string: "https://api.twitter.com/1.1/statuses/user_timeline.json?screen_name=jairbolsonaro&count=\(count)&include_rts=\(querySettings[0])&exclude_replies=\(!querySettings[1])") else { completion(.failure(NetworkResponse.failed)); return }
        
        var request = URLRequest(url: url)
        request.addValue(("Bearer " + bearerToken), forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error { completion(.failure(error)); return }
            if let response = response as? HTTPURLResponse {
                let result = handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let data = data else { completion(.failure(NetworkResponse.noData)); return }
                    do {
                        let jsonTweets = try JSONDecoder().decode([TweetObject].self, from: data)
                        var tweets = [Tweet]()
                        for json in jsonTweets {
                            guard let tweet = Tweet(json) else { completion(.failure(NetworkResponse.unableToDecode)); return }
                            tweets.append(tweet)
                        }
                        completion(.success(tweets))
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    static func fetchImage(for url: String, completion: @escaping (Result <UIImage, Error>) -> Void) {
        guard let imageUrl = URL(string: url) else { completion(.failure(NetworkResponse.failed)); return }
        
        var request = URLRequest(url: imageUrl)
        request.addValue(("Bearer " + bearerToken), forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error { completion(.failure(error)); return }
            
            if let httpURLResponse = response as? HTTPURLResponse {
                let result = handleNetworkResponse(httpURLResponse)
                
                switch result {
                    
                case .success:
                    guard let imageData = data,
                        let image = UIImage(data: imageData) else { completion(.failure(NetworkResponse.noData)); return }
                    completion(.success(image))
                    
                case .failure( let error):
                    completion(.failure(error))
                    return
                }
            }
            }.resume()
    }
    
    static func checkForNewTweets() -> Bool {
        return false
    }
    
    // MARK: - Authentication
    
    fileprivate static var bearerToken: String {
        guard let filepath = Bundle.main.path(forResource: "Authentication", ofType: "plist") else { print("Authentication.plist not found."); return "error" }
        let propertyList = NSDictionary.init(contentsOfFile: filepath)
        guard let bToken = propertyList?.value(forKey: "BearerToken") as? String else { print("Improper drilling into PropertyList file."); return "" }
        return bToken
    }
    
    fileprivate static var apiKey: String {
        guard let filepath = Bundle.main.path(forResource: "Authentication", ofType: "plist") else { print("Authentication.plist not found."); return "error" }
        let propertyList = NSDictionary.init(contentsOfFile: filepath)
        guard let APIKey = propertyList?.value(forKey: "APIKey") as? String else { print("Improper drilling into PropertyList file."); return "" }
        return APIKey
    }
}
