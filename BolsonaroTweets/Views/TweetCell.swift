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
        dateLabel.text = date
        tweetTextLabel.text = text
    }
}
