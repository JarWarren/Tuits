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
        TweetController.fetchTweets { (result) in
            
            switch result {
                
            case .success(let tweets):
                
                self.tweets = tweets
                
                DispatchQueue.main.async {
                    
                    self.bolsoTableView.reloadData()
                }
                
            case .failure(let error):
                
                let alertController = UIAlertController(title: "Network Error", message: error.localizedDescription, preferredStyle: .actionSheet)
                let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alertController.addAction(ok)
                self.present(alertController, animated: true)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let request = DFPRequest()
        request.testDevices = ["1e6e76e8d8c1f2588d47e3515fda0a76"]
        
        bannerView.adUnitID = "/6499/example/banner"
        bannerView.rootViewController = self
        bannerView.load(request)
        bannerView.adSize = kGADAdSizeBanner
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
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.7189847827, green: 0.887085259, blue: 0.5935872197, alpha: 1)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.7189847827, green: 0.887085259, blue: 0.5935872197, alpha: 1)
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "bolCell", for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
       
        let action1 = UIContextualAction(style: .normal, title: "Compartilhar") { (_, _, _) in
        }
        let action2 = UIContextualAction(style: .normal, title: "Abrir") { (_, _, _) in
        }
        
        action1.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        action2.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        return UISwipeActionsConfiguration(actions: [action1, action2])
    }
}
