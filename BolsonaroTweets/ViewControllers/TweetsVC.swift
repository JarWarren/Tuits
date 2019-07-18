//
//  TweetsVC.swift
//  BolsonaroTweets
//
//  Created by Jared Warren on 2/28/19.
//  Copyright © 2019 Warren. All rights reserved.
//  swiftlint:disable identifier_name line_length

import UIKit
import GoogleMobileAds

class TweetsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var bolsoTableView: UITableView!
    @IBOutlet weak var bannerView: DFPBannerView!
    
    var tweets = [Tweet]()
    var querySettingsDidChange = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bolsoTableView.delegate = self
        bolsoTableView.dataSource = self
        bolsoTableView.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "tableViewBG"))
        tabBarController?.tabBar.items?[1].title = "Settings".localize
        fetchTweets()
        
        NotificationCenter.default.addObserver(self, selector: #selector(prepareForFetch), name: NSNotification.Name(rawValue: Setting.toggleKey), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AdManager.displayLiveAds(to: bannerView, on: self, adUnitName: "Tab1")
        if querySettingsDidChange {
            fetchTweets()
        } else {
            bolsoTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let tweet = tweets[indexPath.row]
        
        switch tweet.type {
            
        case .original:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as? TweetCell else { return UITableViewCell() }
            cell.tweetImageView.image = nil
            cell.tweet = tweet
            return cell
            
        case .retweet:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "retweetCell", for: indexPath) as? RetweetCell else { return UITableViewCell() }
            cell.tweetImageView.image = nil
            cell.tweet = tweet
            return cell
            
        case .quote:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "quoteCell", for: indexPath) as? QuoteCell else { return UITableViewCell() }
            cell.tweet = tweet
            return cell
            
        default: break
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
       
        if let cell = tableView.cellForRow(at: indexPath) as? TweetCell,
            let tweet = cell.tweet {
            return actionsFor(tweet)
        } else if let cell = tableView.cellForRow(at: indexPath) as? RetweetCell,
            let tweet = cell.tweet {
            return actionsFor(tweet)
        } else if let cell = tableView.cellForRow(at: indexPath) as? QuoteCell,
            let tweet = cell.tweet {
            return actionsFor(tweet)
        } else {
            return nil
        }
    }
    
    @objc func prepareForFetch() {
        querySettingsDidChange = true
    }
    
    func fetchTweets() {
        TweetController.fetchTweets { (result) in
            
            switch result {
                
            case .success(let tweets):
                
                self.tweets = tweets
                
                DispatchQueue.main.async {
                    
                    self.bolsoTableView.reloadData()
                }
                
            case .failure(let error):
                
                let alertController = UIAlertController(title: "Network Error".localize, message: error.localizedDescription, preferredStyle: .actionSheet)
                let ok = UIAlertAction(title: "Ok".localize, style: .default, handler: nil)
                alertController.addAction(ok)
                self.present(alertController, animated: true)
            }
        }
    }
    
    func actionsFor(_ tweet: Tweet) -> UISwipeActionsConfiguration {
        
        let tweetID =  "\(tweet.id)"
        
        let action1 = UIContextualAction(style: .normal, title: nil) { (_, _, _) in
            
            let appURL = NSURL(string: "twitter://status?id=\(tweetID)")!
            let webURL = NSURL(string: "https://twitter.com/status/\(tweetID)")!
            
            let application = UIApplication.shared
            
            if application.canOpenURL(appURL as URL) {
                application.open(appURL as URL)
            } else {
                application.open(webURL as URL)
            }
            
        }
        let action2 = UIContextualAction(style: .normal, title: nil) { (_, _, _) in
            
            guard UIDevice.current.userInterfaceIdiom == .phone else { return }
            
            let activityItem: URL = URL(string: "https://twitter.com/jairbolsonaro/status/\(tweetID)")!
            
            let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [activityItem], applicationActivities: nil)
            
            self.present(activityViewController, animated: true, completion: nil)
        }
        
        action1.backgroundColor = #colorLiteral(red: 0.1143526807, green: 0.6294203997, blue: 0.9512725472, alpha: 1)
        action1.image = #imageLiteral(resourceName: "twitter")
        action2.backgroundColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        action2.image = #imageLiteral(resourceName: "share")
        return UISwipeActionsConfiguration(actions: [action2, action1])
    }
}
