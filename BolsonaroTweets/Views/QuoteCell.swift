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
    @IBOutlet weak var quoteView: UIView!
    @IBOutlet weak var quoteProfilePic: UIImageView!
    @IBOutlet weak var quoteName: UILabel!
    @IBOutlet weak var quoteHandle: UILabel!
    @IBOutlet weak var quoteDate: UILabel!
    @IBOutlet weak var quoteText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profilePic.layer.cornerRadius = profilePic.frame.width / 2
        quoteView.layer.shadowColor = UIColor.lightGray.cgColor
        quoteView.layer.shadowRadius = 6
        quoteView.layer.shadowOpacity = 1
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
        
        guard let qName = tweet?.quote?.name,
            let qHandle = tweet?.quote?.handle,
            let qDate = tweet?.quote?.date,
            let qText = tweet?.quote?.text else { return }
        
        quoteName.text = qName
        quoteHandle.text = "@" + qHandle
        quoteDate.text = qDate.asLocalizedDate
        quoteText.attributedText = qText.tweetFormatted
        
        guard let qPicURL = tweet?.quote?.imageURL else { return }
        
        TweetController.fetchImageAt(url: qPicURL) { (result) in
            switch result {
            case .success(let quotePic):
                DispatchQueue.main.async {
                    self.quoteProfilePic.image = quotePic
                }
            case .failure: break
            }
        }
    }
}
