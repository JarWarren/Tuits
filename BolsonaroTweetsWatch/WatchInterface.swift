//
//  WatchInterface.swift
//  BolsonaroTweets
//
//  Created by Jared Warren on 7/23/19.
//  Copyright © 2019 Warren. All rights reserved.
//

import WatchKit

class WatchInterface: WKInterfaceController {

    @IBOutlet weak var nameLabel: WKInterfaceLabel!
    @IBOutlet weak var verifiedLabel: WKInterfaceImage!
    @IBOutlet weak var handleLabel: WKInterfaceLabel!
    @IBOutlet weak var dateLabel: WKInterfaceLabel!
    @IBOutlet weak var textLabel: WKInterfaceLabel!
    @IBOutlet weak var profilePicView: WKInterfaceImage!
    //    TODO: add indicator for "retweeted"
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
    }
}
