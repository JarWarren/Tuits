//
//  QuoteCell.swift
//  BolsonaroTweets
//
//  Created by Jared Warren on 5/4/19.
//  Copyright © 2019 Warren. All rights reserved.
//

import UIKit

class QuoteCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    
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
        
        guard let name = tweet?.name,
            let handle = tweet?.handle,
            let date = tweet?.date,
            let text = tweet?.text else { return }
        
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
        
        // TODO: Unwrap quote object and fetch quote profilepic
    }
}
