//
//  AppStoreReviewManager.swift
//  EasyEnglish
//
//  Created by Anh Dũng on 8/12/19.
//  Copyright © 2019 Anh Dũng. All rights reserved.
//

import StoreKit

@available(iOS 10.3, *)
enum AppStoreReviewManager {
    // 1.
    static let minimumReviewWorthyActionCount = 5
    
    static func requestReviewIfAppropriate() {
        let defaults = UserDefaults.standard
        let bundle = Bundle.main
        
        // 2.
        var actionCount = defaults.integer(forKey: "reviewWorthyActionCount")
        
        // 3.
        actionCount += 1
        
        // 4.
        defaults.set(actionCount, forKey: "reviewWorthyActionCount")
        
        // 5.
        guard actionCount >= minimumReviewWorthyActionCount else {
            return
        }
        
        // 6.
//        let bundleVersionKey = kCFBundleVersionKey as String
//        let currentVersion = bundle.object(forInfoDictionaryKey: bundleVersionKey) as? String
//        let lastVersion = defaults.string(forKey: "lastReviewRequestAppVersion")
//
//        // 7.
//        guard lastVersion == nil || lastVersion != currentVersion else {
//            return
//        }
        
        // 8.
        SKStoreReviewController.requestReview()
        
        // 9.
        defaults.set(0, forKey: "reviewWorthyActionCount")
//        defaults.set(currentVersion, forKey: "lastReviewRequestAppVersion")
    }
    
    static func requestReviewNow() {
        SKStoreReviewController.requestReview()
    }
}
