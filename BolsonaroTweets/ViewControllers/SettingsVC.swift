//
//  SecondViewController.swift
//  BolsonaroTweets
//
//  Created by Jared Warren on 2/28/19.
//  Copyright © 2019 Warren. All rights reserved.
//

import UIKit
import GoogleMobileAds

class SecondViewController: UIViewController {

    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var languageButton: UIButton!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var retweetSwitch: UISwitch!
    @IBOutlet weak var replyLabel: UILabel!
    @IBOutlet weak var replySwitch: UISwitch!
    @IBOutlet weak var bannerView: DFPBannerView!
    
    weak var delegate: SettingsVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch LocalizationManager.shared.activeLanguage.first {
        case "en":
            setToEnglish()
        default:
            definirParaOPortugues()
        }
        
        retweetSwitch.isOn = SettingsController.shared.allSettings["Retweets"] ?? false
        replySwitch.isOn = SettingsController.shared.allSettings["Replies"] ?? false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        AdManager.displayLiveAds(to: bannerView, on: self, adUnitName: "Tab2")
    }

    @IBAction func languageButtonTapped(_ sender: UIButton) {
        
        switch sender.imageView?.image {
        case #imageLiteral(resourceName: "en"):
            definirParaOPortugues()
        case #imageLiteral(resourceName: "pt"):
            setToEnglish()
        default:
            break
        }
        LocalizationManager.shared.saveLanguage()
    }
    
    @IBAction func retweetSwitchSwitched(_ sender: UISwitch) {
        
        SettingsController.shared.shouldIncludeRetweets(bool: sender.isOn)
        delegate?.fetchTweets()
    }
    
    @IBAction func replySwitchSwitched(_ sender: UISwitch) {

        SettingsController.shared.shouldExcludeReplies(bool: sender.isOn)
        delegate?.fetchTweets()
    }
    
    func setToEnglish() {
        
        LocalizationManager.shared.setToEnglish()
        languageButton.setImage(#imageLiteral(resourceName: "en"), for: .normal)
        settingsLabel.text = "Settings"
        retweetLabel.text = "Include retweets:"
        replyLabel.text = "Include replies:"
        tabBarController?.tabBar.items?[1].title = "Settings"
    }
    
    func definirParaOPortugues() {
        
        LocalizationManager.shared.definirParaOPortuguês()
        languageButton.setImage(#imageLiteral(resourceName: "pt"), for: .normal)
        settingsLabel.text = "Configurações"
        retweetLabel.text = "Incluir retweets:"
        replyLabel.text = "Incluir respostas:"
        tabBarController?.tabBar.items?[1].title = "Configurações"
    }
}

protocol SettingsVCDelegate: class {
    
    func fetchTweets()
}
