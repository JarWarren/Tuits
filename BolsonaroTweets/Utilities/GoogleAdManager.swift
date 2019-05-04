//
//  GoogleAdManager.swift
//  BolsonaroTweets
//
//  Created by Jared Warren on 4/7/19.
//  Copyright © 2019 Warren. All rights reserved.
//

import Foundation
import GoogleMobileAds

struct AdManager {
    
    static func displayBannerAds(on banner: DFPBannerView, for rootViewController: UIViewController) {
        
        let request = DFPRequest()
        request.testDevices = ["1e6e76e8d8c1f2588d47e3515fda0a76"]
        
        banner.adUnitID = "/6499/example/banner"
        banner.rootViewController = rootViewController
        banner.load(request)
        banner.adSize = kGADAdSizeBanner
        banner.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }
}
