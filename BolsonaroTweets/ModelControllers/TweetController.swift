//
//  TweetController.swift
//  BolsonaroTweets
//
//  Created by Jared Warren on 3/1/19.
//  Copyright © 2019 Warren. All rights reserved.
//  swiftlint:disable line_length

import Foundation

class TweetController: NetworkManager {
    
    // MARK: - GET Request
    
    static func fetchTweets(completion: @escaping (Result <[Tweet], Error>) -> Void) {
        
        guard let baseURL = URL(string: "https://api.twitter.com/1.1/statuses/user_timeline.json?screen_name=jairbolsonaro&count=24&tweet_mode=extended&include_rts=false") else { completion(.failure(NetworkResponse.failed)); return }
        
        var request = URLRequest(url: baseURL)
        request.addValue(("Bearer " + bearerToken), forHTTPHeaderField: "Authorization")
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                
                completion(.failure(error))
                return
            }
            
            if let response = response as? HTTPURLResponse {
                let result = handleNetworkResponse(response)
                
                switch result {
                    
                case .success:
                    
                    guard let data = data else { completion(.failure(NetworkResponse.noData)); return }
                    
                    do {
                        
                        let timeline = try JSONDecoder().decode([Tuit].self, from: data)
                        
                        var tweets = [Tweet]()
                        
                        for tuit in timeline {
                            
                            guard let tweet = Tweet(tuit: tuit) else { completion(.failure(NetworkResponse.unableToDecode)); return }
                            tweets.append(tweet)
                        }
                        
                        guard tweets.isEmpty == false else { completion(.failure(NetworkResponse.unableToDecode)); return }
                        completion(.success(tweets))
                        return
                        
                    } catch {
                        
                        completion(.failure(error))
                    }
                    
                case .failure(let networkFailureError):
                    completion(.failure(networkFailureError))
                    return
                }
            }
        }
        dataTask.resume()
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
