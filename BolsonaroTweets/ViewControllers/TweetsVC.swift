//
//  TweetsVC.swift
//  BolsonaroTweets
//
//  Created by Jared Warren on 2/28/19.
//  Copyright © 2019 Warren. All rights reserved.
//  swiftlint:disable identifier_name line_length

import UIKit

class TweetsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var bolsoTableView: UITableView!
    
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
        view.backgroundColor = #colorLiteral(red: 0.0196332261, green: 0.6651400328, blue: 0.2522620261, alpha: 1)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.0196332261, green: 0.6651400328, blue: 0.2522620261, alpha: 1)
        return view
    }
}
