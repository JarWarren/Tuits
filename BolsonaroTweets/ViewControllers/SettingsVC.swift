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

    @IBOutlet weak var bannerView: DFPBannerView!
    @IBOutlet weak var languageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch LocalizationManager.shared.activeLanguage.first {
        case "en":
            languageButton.setImage(UIImage(named: "en"), for: .normal)
        default:
            languageButton.setImage(UIImage(named: "pt"), for: .normal)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let request = DFPRequest()
        request.testDevices = ["1e6e76e8d8c1f2588d47e3515fda0a76"]
        
        bannerView.adUnitID = "/6499/example/banner"
        bannerView.rootViewController = self
        bannerView.load(request)
        bannerView.adSize = kGADAdSizeBanner
    }

    @IBAction func languageButtonTapped(_ sender: UIButton) {
        
        switch sender.imageView?.image {
        case #imageLiteral(resourceName: "en"):
            LocalizationManager.shared.definirParaOPortuguês()
            sender.setImage(#imageLiteral(resourceName: "pt"), for: .normal)
        case #imageLiteral(resourceName: "pt"):
            LocalizationManager.shared.setToEnglish()
            sender.setImage(#imageLiteral(resourceName: "en"), for: .normal)
        default:
            break
        }
        self.tabBarController?.reloadInputViews()
        LocalizationManager.shared.saveLanguage()
    }
}
