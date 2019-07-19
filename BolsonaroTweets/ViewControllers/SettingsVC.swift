//
//  SecondViewController.swift
//  BolsonaroTweets
//
//  Created by Jared Warren on 2/28/19.
//  Copyright © 2019 Warren. All rights reserved.
//  swiftlint:disable line_length

import UIKit
import GoogleMobileAds

class SettingsVC: UIViewController {

    // MARK: - Outlets and Properties
    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var languageButton: UIButton!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var retweetSwitch: UISwitch!
    @IBOutlet weak var replyLabel: UILabel!
    @IBOutlet weak var replySwitch: UISwitch!
    @IBOutlet weak var bannerView: DFPBannerView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add an observer to make sure language is always reflected accurately
        NotificationCenter.default.addObserver(self, selector: #selector(updateViewLanguage), name: NSNotification.Name(rawValue: Setting.languageKey), object: nil)
        
        // Make sure view reflects currentLanguage
        updateViewLanguage()
        
        // Fetch values for toggle settings, assign them to switches.
        let toggleSettings = SettingsManager.valuesForToggleSettings([.retweets,
                                                                      .replies])
        retweetSwitch.isOn = toggleSettings[0]
        replySwitch.isOn = toggleSettings[1]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        AdManager.displayLiveAds(to: bannerView, on: self, adUnitName: "Tab2")
    }

    // MARK: - Actions
    @IBAction func languageButtonTapped(_ sender: UIButton) {
        
        if sender.imageView?.image == UIImage(named: "en") {
            SettingsManager.changeLanguage(to: .portuguese)
        } else {
            SettingsManager.changeLanguage(to: .english)
        }
    }
    
    @IBAction func retweetSwitchSwitched(_ sender: UISwitch) {
        
        SettingsManager.updateToggleSetting(.retweets, to: sender.isOn)
    }
    
    @IBAction func replySwitchSwitched(_ sender: UISwitch) {

        SettingsManager.updateToggleSetting(.replies, to: sender.isOn)
    }
    
    // MARK: - Methods
    @objc func updateViewLanguage() {
        languageButton.setImage(UIImage(named: SettingsManager.currentLanguage()), for: .normal)
        settingsLabel.text = "Settings".localize
        languageLabel.text = "Language:".localize
        retweetLabel.text = "Include retweets:".localize
        replyLabel.text = "Include replies:".localize
    }
}
