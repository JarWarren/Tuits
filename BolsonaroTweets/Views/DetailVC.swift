//
//  DetailVC.swift
//  BolsonaroTweets
//
//  Created by Jared Warren on 7/20/19.
//  Copyright © 2019 Warren. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var bolsoCollectionView: UICollectionView!
    
    func updateView(with tweet: Tweet) {
        loadViewIfNeeded()
        nameLabel.text = tweet.name
        handleLabel.text = "@" + tweet.handle
        dateLabel.text = tweet.date.asLocalizedDate
        tweetTextLabel.attributedText = tweet.text.tweetFormatted
        
        TweetController.fetchImageAt(url: tweet.profilePicURL) { (result) in
            switch result {
            case .success(let profilePicture):
                DispatchQueue.main.async {
                    self.profileImageView.image = profilePicture
                }
            case .failure: break
            }
        }
    }
    @IBAction func dismissButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func goToTwitterButtonTapped(_ sender: Any) {
    }
}
