//
//  AdmobManager.swift
//  MangaReader
//
//  Created by Nhuom Tang on 9/9/18.
//  Copyright © 2018 Nhuom Tang. All rights reserved.
//

import UIKit
import GoogleMobileAds

let adSize = UIDevice.current.userInterfaceIdiom == .pad ? kGADAdSizeLeaderboard: kGADAdSizeBanner
let numberToShowAd = 10
let keyBanner = ""
let keyInterstitial = ""

class AdmobManager: NSObject {
    
    static let shared = AdmobManager()
    
    var interstitial: GADInterstitial!
    var loadBannerError = true
    var isShowAds = false
    var counter = 1
    var loadFullAdError = false
    
    var fullRootViewController: UIViewController!

    func setBannerViewToBottom(inVC: UIViewController, banerView: GADBannerView){
        let witdh = UIScreen.main.bounds.size.width
        let height: CGFloat = inVC.view.bounds.size.height
        var bottomSafe: CGFloat = 0.0
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            if let bottomPadding = window?.safeAreaInsets.bottom{
                bottomSafe = bottomPadding
            }else{
                bottomSafe = 0
            }
        }else{
            bottomSafe = 0
        }
        
        let frame = CGRect.init(x: (witdh - adSize.size.width)/2 , y: height - adSize.size.height - bottomSafe, width: adSize.size.width, height: adSize.size.height)
        banerView.frame = frame
    }
    
    func addBannerViewToBottom(inVC: UIViewController){
        let witdh = UIScreen.main.bounds.size.width
        let height: CGFloat = inVC.view.bounds.size.height
        let frame = CGRect.init(x: (witdh - adSize.size.width)/2 , y: height - adSize.size.height, width: adSize.size.width, height: adSize.size.height)
        self.addBannerView(frame: frame, inVC: inVC)
    }
    
    func addBannerViewToTop(inVC: UIViewController){
        let witdh = UIScreen.main.bounds.size.width
        let frame = CGRect.init(x: (witdh - adSize.size.width)/2 , y: 0, width: adSize.size.width, height: adSize.size.height)
        self.addBannerView(frame: frame, inVC: inVC)
    }
    
    func statusBarHeight() -> CGFloat {
        let statusBarSize = UIApplication.shared.statusBarFrame.size
        return Swift.min(statusBarSize.width, statusBarSize.height)
    }

    override init() {
        super.init()
        self.createAndLoadInterstitial()
        counter = numberToShowAd - 2
    }
    
    func openRateView(){
//        SKStoreReviewController.requestReview()
    }
    
    func addBannerView(frame: CGRect, inVC: UIViewController){
        let bannerView = GADBannerView.init(adSize: adSize)
        bannerView.adUnitID = keyBanner
        bannerView.rootViewController = inVC
        bannerView.delegate = self
        bannerView.frame = frame
        inVC.view.addSubview(bannerView)
        bannerView.load(GADRequest())
    }
        
    func createBannerView(inVC: UIViewController) -> GADBannerView{
        let witdh = UIScreen.main.bounds.size.width
        let frame = CGRect.init(x: (witdh - adSize.size.width)/2 , y: 2000, width: adSize.size.width, height: adSize.size.height)
        let bannerView = GADBannerView.init(adSize: adSize)
        bannerView.adUnitID = keyBanner
        bannerView.rootViewController = inVC
        bannerView.delegate = self
        bannerView.frame = frame
        inVC.view.addSubview(bannerView)
        let request = GADRequest()
        request.testDevices = [ kGADSimulatorID, "c7f5d0314287e72fdcba00545320b656","48dc4326e9c28206e73446cdeeff5f86"]
        bannerView.load(request)

        return bannerView
    }
    
    func createAndLoadInterstitial() {
        interstitial = GADInterstitial(adUnitID: keyInterstitial)
        interstitial.delegate = self
        let request = GADRequest()
        request.testDevices = [ kGADSimulatorID, "c7f5d0314287e72fdcba00545320b656","48dc4326e9c28206e73446cdeeff5f86"]
        interstitial.load(request)
    }
    
    func logEvent(){
        if self.loadFullAdError {
            self.createAndLoadInterstitial()
            self.loadFullAdError = false
        }
        counter = counter + 1
        if  counter >= numberToShowAd {
            if interstitial.isReady{
                interstitial.present(fromRootViewController: fullRootViewController)
                counter = 1
                isShowAds = true
            }else{
                self.openRateView()
            }
        }else{
            if isShowAds{
                isShowAds = false
                self.openRateView()
            }
        }
    }
    
    func forceShowAdd(){
        counter = numberToShowAd
        self.logEvent()
    }
}

extension AdmobManager: GADBannerViewDelegate{
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("adViewDidReceiveAd")
        loadBannerError = false
    }
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("didFailToReceiveAdWithError bannerView")
        loadBannerError = true
    }
}

extension AdmobManager: GADInterstitialDelegate{
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        self.createAndLoadInterstitial()
    }
    
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        loadFullAdError = true
        print("didFailToReceiveAdWithError GADInterstitial")
    }
    
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        print("interstitialDidReceiveAd")
    }
}

