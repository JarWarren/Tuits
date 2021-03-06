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

    // MARK: - Outlets and Properties
    @IBOutlet weak var bolsoTableView: UITableView!
    @IBOutlet weak var bannerView: DFPBannerView!
    
    var tweets = [Tweet]()
    var querySettingsDidChange = false
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bolsoTableView.delegate = self
        bolsoTableView.dataSource = self
        bolsoTableView.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "tableViewBG"))
        AdManager.displayLiveAds(to: bannerView, on: self, adUnitName: "Tab1")
        tabBarController?.tabBar.items?[1].title = "Settings".localize
        fetchTweets()
        
        NotificationCenter.default.addObserver(self, selector: #selector(prepareForFetch), name: NSNotification.Name(rawValue: Setting.toggleKey), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if querySettingsDidChange {
            fetchTweets()
        }
    }
    
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let tweet = tweets[indexPath.row]
        print(tweet.mediaType as Any)
        if tweet.type != .quote {
            let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as? TweetCell
            cell?.tweet = tweet
            cell?.backgroundColor = tweet.mediaType != nil || tweet.quote?.type != nil ? #colorLiteral(red: 0.9402887821, green: 0.940446198, blue: 0.9402680397, alpha: 1) : .white
            return cell ?? UITableViewCell()
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "quoteCell", for: indexPath) as? QuoteCell
            cell?.tweet = tweet
            cell?.backgroundColor = tweet.mediaType == nil ? .white : #colorLiteral(red: 0.9402887821, green: 0.940446198, blue: 0.9402680397, alpha: 1)
            return cell ?? UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let tweet = tweets[indexPath.row]
        
        guard let detailVC = UIStoryboard(name: "Detail", bundle: nil).instantiateInitialViewController() as? DetailVC else { return }
    
        switch tweet.type {
        case .quote:
            let cell = tableView.cellForRow(at: indexPath) as? QuoteCell
            guard let profilePic = cell?.quoteProfilePic.image else { return }
            detailVC.updateView(with: tweet, profilePic: profilePic)
        default:
            let cell = tableView.cellForRow(at: indexPath) as? TweetCell
            guard let profilePic = cell?.profilePic.image else { return }
            detailVC.updateView(with: tweet, profilePic: profilePic)
        }
        present(detailVC, animated: false)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
       
        if let cell = tableView.cellForRow(at: indexPath) as? TweetCell,
            let tweet = cell.tweet {
            return actionsFor(tweet)
        } else if let cell = tableView.cellForRow(at: indexPath) as? QuoteCell,
            let tweet = cell.tweet {
            return actionsFor(tweet)
        } else {
            return nil
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
        
        action1.backgroundColor = #colorLiteral(red: 0.1136763319, green: 0.7917308211, blue: 0.9969540238, alpha: 1)
        action1.image = #imageLiteral(resourceName: "twitter")
        action2.backgroundColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        action2.image = #imageLiteral(resourceName: "share")
        return UISwipeActionsConfiguration(actions: [action2, action1])
    }
    
    // MARK: - Methods
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
                    self.querySettingsDidChange = false
                }
                
            case .failure(let error):
                
                let alertController = UIAlertController(title: "Network Error".localize, message: error.localizedDescription, preferredStyle: .actionSheet)
                let ok = UIAlertAction(title: "Ok".localize, style: .default, handler: nil)
                alertController.addAction(ok)
                self.present(alertController, animated: true)
            }
        }
    }
}
