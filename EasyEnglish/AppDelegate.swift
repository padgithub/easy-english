//
//  AppDelegate.swift
//  EasyEnglish
//
//  Created by Anh Dũng on 12/28/18.
//  Copyright © 2018 Anh Dũng. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var tabVC: UITabBarController?
    var isShowZoomOutView = true
    var isPlay = false
    var isNew = false
    var deviceOrientation = UIInterfaceOrientationMask.portrait
    var handleReturnForeground: (() -> Void)?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        youtubeShare.turnAudio()
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: "HelveticaNeue", size: 12) as Any, NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        UITabBar.appearance().unselectedItemTintColor = UIColor("9D271B", alpha: 1.0)
        UITabBar.appearance().tintColor = UIColor.white
        
        initMainVC()
        return true
    }
    
    func initMainVC()  {
        let vc = initTabVC(0)
        let nav = UINavigationController(rootViewController: vc)
        nav.isNavigationBarHidden = true
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
    }
    
    func initPlayVC()  {
        let vc = PlayVC(nibName: "PlayVC",bundle: nil)
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
    }
    
    func initTabVC(_ index: Int) -> UITabBarController{
        
        let tabVC = UITabBarController()
        tabVC.tabBar.barTintColor = UIColor.clear
        tabVC.tabBar.backgroundImage = nil
        tabVC.tabBar.shadowImage = nil
        tabVC.tabBar.layer.borderWidth = 0.0
        tabVC.tabBar.clipsToBounds = true
        tabVC.tabBar.contentMode = .scaleToFill
        tabVC.tabBar.isTranslucent = false
        //
        let tabP = MainVC(nibName:"MainVC",bundle: nil)
        tabP.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "ic_bb_home")!.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "ic_bb_home")!.withRenderingMode(.alwaysOriginal))
        let navP = UINavigationController(rootViewController: tabP)
        navP.isNavigationBarHidden = true
        
        let tabT = TrendingVC(nibName:"TrendingVC",bundle: nil)
        tabT.tabBarItem = UITabBarItem(title: "Trengding", image: UIImage(named: "ic_bb_trengding")!.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "ic_bb_trengding")!.withRenderingMode(.alwaysOriginal))
        let navT = UINavigationController(rootViewController: tabT)
        navT.isNavigationBarHidden = true
        
        let tabF = FavoritesVC(nibName:"FavoritesVC",bundle: nil)
        tabF.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(named: "ic_bb_sub")!.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "ic_bb_sub")!.withRenderingMode(.alwaysOriginal))
        let navF = UINavigationController(rootViewController: tabF)
        navF.isNavigationBarHidden = true
        
        let tabM = InboxVC(nibName:"InboxVC",bundle: nil)
        tabM.tabBarItem = UITabBarItem(title: "Inbox", image: UIImage(named: "ic_bb_mail")!.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "ic_bb_mail")!.withRenderingMode(.alwaysOriginal))
        let navM = UINavigationController(rootViewController: tabM)
        navM.isNavigationBarHidden = true
        
        let tabL = LibraryVC(nibName:"LibraryVC",bundle: nil)
        tabL.tabBarItem = UITabBarItem(title: "Library", image: UIImage(named: "ic_bb_libray")!.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "ic_bb_libray")!.withRenderingMode(.alwaysOriginal))
        let navL = UINavigationController(rootViewController: tabL)
        navL.isNavigationBarHidden = true
        
        tabVC.viewControllers = [navP, navT, navF, navM, navL]
        tabVC.selectedIndex = index
        return tabVC
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        print("applicationWillResignActive")
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        youtubeShare.handlePlayWhenPause = {
            Timer.every(0.001) {
                if self.isPlay {
                    viewYoutubePlayer.play()
                }
            }
        }
        print("applicationDidEnterBackground")
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        handleReturnForeground?()
        print("applicationWillEnterForeground")
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        print("applicationDidBecomeActive")
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        print("applicationWillTerminate")
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return deviceOrientation
    }
}
