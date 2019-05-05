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
    @IBOutlet weak var imageViewButton: UIButton!
    @IBOutlet weak var verifiedImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profilePic.layer.cornerRadius = profilePic.frame.width / 2
    }
    
    var tweet: Tweet? {
        didSet {
            updateCell()
        }
    }
    
    func updateCell() {
        
        guard let type = tweet?.tweetType,
            let name = tweet?.name,
            let handle = tweet?.handle,
            let date = tweet?.date,
            let text = tweet?.text else { return }
        
        switch type {
        case .retweet:
            verifiedImageView.image = #imageLiteral(resourceName: "retweet")
        default:
            verifiedImageView.image = #imageLiteral(resourceName: "verified")
            
        }
        
        nameLabel.text = name
        handleLabel.text = "@" + handle
        dateLabel.text = date.asLocalizedDate
        tweetTextLabel.text = text
        
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
        
        guard let firstMediaURL = tweet?.mediaURLs.first else { return }
        TweetController.fetchImageAt(url: firstMediaURL) { (result) in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self.imageViewButton.setBackgroundImage(image, for: .normal)
                    self.layoutIfNeeded()
                }
            case .failure: break
            }
        }
    }
}
