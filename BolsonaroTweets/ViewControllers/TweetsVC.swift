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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bolsoTableView.delegate = self
        bolsoTableView.dataSource = self
        tabBarController?.tabBar.items?[1].title = "Settings".localize
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        AdManager.displayBannerAds(on: bannerView, for: self)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bolCell", for: indexPath)
        if let cell = cell as? TweetCell {
            
            cell.tweet = tweets[indexPath.section]
        }
        
        return cell
    }
    
    // TODO: Remove headers and footers. I only have one section. Just add a border and corner radius to each cell in cellForRowAt.
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
       
        guard let cell = tableView.cellForRow(at: indexPath) as? TweetCell,
        let tweet = cell.tweet else { return nil }
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
