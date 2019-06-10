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
    
    static func displayTestAds(to banner: DFPBannerView, on rootViewController: UIViewController) {
        
        let request = DFPRequest()
        request.testDevices = ["1e6e76e8d8c1f2588d47e3515fda0a76"]
        
        banner.adUnitID = "/6499/example/banner"
        banner.rootViewController = rootViewController
        banner.load(request)
        banner.adSize = kGADAdSizeBanner
        banner.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }
    
    static func displayLiveAds(to banner: DFPBannerView, on rootViewController: UIViewController, adUnitName: String) {
        
        // todo: make a request
        let request = DFPRequest()
        request.testDevices = ["1e6e76e8d8c1f2588d47e3515fda0a76"]
        
        banner.adUnitID = adUnitID(from: adUnitName)
        banner.rootViewController = rootViewController
        banner.load(request)
        banner.adSize = kGADAdSizeBanner
    }
    
    fileprivate static func adUnitID(from adUnitID: String) -> String {
        guard let filepath = Bundle.main.path(forResource: "AdUnits", ofType: "plist") else { return "error" }
        let propertyList = NSDictionary.init(contentsOfFile: filepath)
        guard let adUnitID = propertyList?.value(forKey: adUnitID) as? String else { return "error" }
        return adUnitID
    }
}
