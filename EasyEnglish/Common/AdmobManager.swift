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
let numberToShowAd = 5

let keyBanner = "ca-app-pub-5652014623246123/3323595396"
let keyInterstitial = "ca-app-pub-5652014623246123/4268231155"

class AdmobManager: NSObject {
    
    static let shared = AdmobManager()
    
    var interstitial: GADInterstitial!
    var loadBannerError = true
    var isShowAds = false
    var counter = 1
    var loadFullAdError = false
    var bottomSafe: CGFloat = 0.0
    var fullRootViewController: UIViewController!
    
    override init() {
        super.init()
        self.createAndLoadInterstitial()
        counter = numberToShowAd - 2
        
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
    }
    
    func setBannerViewToBottom(inVC: UIViewController, banerView: GADBannerView){
        let witdh = UIScreen.main.bounds.size.width
        let height: CGFloat = inVC.view.bounds.size.height
        let frame = CGRect.init(x: (witdh - adSize.size.width)/2 , y: height - adSize.size.height - bottomSafe, width: adSize.size.width, height: adSize.size.height)
        let request = GADRequest()
        request.testDevices = [ kGADSimulatorID, "777465d8c44cabb18c9d65f1f5192b0c2a172ccb"]
        banerView.frame = frame
    }
    
    func addBannerViewToBottom(inVC: UIViewController){
        let witdh = UIScreen.main.bounds.size.width
        let height: CGFloat = inVC.view.bounds.size.height
        let frame = CGRect.init(x: (witdh - adSize.size.width)/2 , y: height - adSize.size.height - bottomSafe, width: adSize.size.width, height: adSize.size.height)
        let request = GADRequest()
        request.testDevices = [ kGADSimulatorID, "777465d8c44cabb18c9d65f1f5192b0c2a172ccb"]
        self.addBannerView(frame: frame, inVC: inVC)
    }
    
    func addBannerViewToTop(inVC: UIViewController){
        let witdh = UIScreen.main.bounds.size.width
        let frame = CGRect.init(x: (witdh - adSize.size.width)/2 , y: 0, width: adSize.size.width, height: adSize.size.height)
        let request = GADRequest()
        request.testDevices = [ kGADSimulatorID, "777465d8c44cabb18c9d65f1f5192b0c2a172ccb"]
        self.addBannerView(frame: frame, inVC: inVC)
    }
    
    func statusBarHeight() -> CGFloat {
        let statusBarSize = UIApplication.shared.statusBarFrame.size
        return Swift.min(statusBarSize.width, statusBarSize.height)
    }

    
    func openRateView(){
        SKStoreReviewController.requestReview()
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
    
    func addBannerInView(view: UIView, inVC: UIViewController){
        let bannerView = GADBannerView.init(adSize: adSize)
        bannerView.adUnitID = keyBanner
        bannerView.rootViewController = inVC
        bannerView.delegate = self
        bannerView.frame = view.bounds
        view.addSubview(bannerView)
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
        request.testDevices = [ kGADSimulatorID, "777465d8c44cabb18c9d65f1f5192b0c2a172ccb"]
        bannerView.load(request)

        return bannerView
    }
    
    func createAndLoadInterstitial() {
        interstitial = GADInterstitial(adUnitID: keyInterstitial)
        interstitial.delegate = self
        let request = GADRequest()
        request.testDevices = [ kGADSimulatorID, "777465d8c44cabb18c9d65f1f5192b0c2a172ccb"]
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
    
    func logEvent(inVC: UIViewController){
        if self.loadFullAdError {
            self.createAndLoadInterstitial()
            self.loadFullAdError = false
        }
        counter = counter + 1
        if  counter >= numberToShowAd {
            if interstitial.isReady{
                interstitial.present(fromRootViewController: inVC)
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
    
    func forceShowAdd(inVC: UIViewController){
        counter = numberToShowAd
        self.logEvent(inVC: inVC)
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

