//
//  DetailVC.swift
//  BolsonaroTweets
//
//  Created by Jared Warren on 7/20/19.
//  Copyright © 2019 Warren. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {

    @IBOutlet var tweetView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var bolsoCollectionView: UICollectionView!
    @IBOutlet weak var retweetStackView: UIStackView!
    @IBOutlet weak var retweetLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "tableViewBG"))
        tweetView.layer.cornerRadius = 6
        tweetView.layer.borderColor = UIColor.black.cgColor
        tweetView.layer.borderWidth = 1
    }
    
    func updateView(with tweet: Tweet, profilePic: UIImage) {
        loadViewIfNeeded()
        
        if tweet.type != .quote {
            nameLabel.text = tweet.name
            handleLabel.text = "@" + tweet.handle
            dateLabel.text = tweet.date.asLocalizedDate
            tweetTextLabel.attributedText = tweet.text.tweetFormatted
            profileImageView.image = profilePic
        } else if let name = tweet.quote?.name,
            let handle = tweet.quote?.handle,
            let date = tweet.quote?.date?.asLocalizedDate,
            let text = tweet.quote?.text?.tweetFormatted {
            nameLabel.text = name
            handleLabel.text = "@" + handle
            dateLabel.text = date
            tweetTextLabel.attributedText = text
            profileImageView.image = profilePic
        }
        retweetStackView.isHidden = tweet.type != .retweet
        retweetLabel.text = "Retweeted".localize
    }
    @IBAction func dismissButtonTapped(_ sender: Any) {
        dismiss(animated: false)
    }
    
    @IBAction func goToTwitterButtonTapped(_ sender: Any) {
    }
}
