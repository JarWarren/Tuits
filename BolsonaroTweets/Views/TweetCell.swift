//
//  TweetCell.swift
//  BolsonaroTweets
//
//  Created by Jared Warren on 3/1/19.
//  Copyright © 2019 Warren. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var retweetStackView: UIStackView!
    @IBOutlet weak var retweetLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var tweet: Tweet? {
        didSet {
            updateCell()
        }
    }
    
    func updateCell() {
        guard let name = tweet?.name,
            let handle = tweet?.handle,
            let date = tweet?.date,
            let text = tweet?.text,
            let type = tweet?.type else { return }
        
        retweetStackView.isHidden = type != .retweet
        retweetLabel.text = "Retweeted".localize
        
        nameLabel.text = name
        handleLabel.text = "@" + handle
        dateLabel.text = date.asLocalizedDate
        tweetTextLabel.attributedText = text.tweetFormatted
        
        guard let profilePicURL = tweet?.profilePicURL else { return }
        
        TweetController.fetchImageAt(url: profilePicURL) { (result) in
            switch result {
            case .success(let profilePicture):
                DispatchQueue.main.async {
                    self.profilePic.image = profilePicture
                }
            case .failure: break
            }
        }
        /*
        guard let firstMediaURL = tweet?.mediaURLs.first else { return }
        tweetImageView.image = #imageLiteral(resourceName: "tabBird")
        TweetController.fetchImageAt(url: firstMediaURL) { (result) in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self.tweetImageView.image = image
                    self.layoutIfNeeded()
                }
            case .failure: break
            }
        }
        */
    }
}
