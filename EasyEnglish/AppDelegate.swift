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
    var deviceOrientation = UIInterfaceOrientationMask.portrait
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
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
        let tabP = MainVC(nibName:"MainVC",bundle: nil)
        tabP.tabBarItem = UITabBarItem(title: "", image: #imageLiteral(resourceName: "ic_auto_play_off").withRenderingMode(.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "ic_auto_play_off").withRenderingMode(.alwaysOriginal))
        let navP = UINavigationController(rootViewController: tabP)
        navP.isNavigationBarHidden = true
        let tabF = MainVC(nibName:"MainVC",bundle: nil)
        tabF.tabBarItem = UITabBarItem(title: "", image: #imageLiteral(resourceName: "ic_auto_play_off").withRenderingMode(.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "ic_auto_play_off").withRenderingMode(.alwaysOriginal))
        let navF = UINavigationController(rootViewController: tabF)
        navF.isNavigationBarHidden = true
        let tabM = MainVC(nibName:"MainVC",bundle: nil)
        tabM.tabBarItem = UITabBarItem(title: "", image: #imageLiteral(resourceName: "ic_auto_play_off").withRenderingMode(.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "ic_auto_play_off").withRenderingMode(.alwaysOriginal))
        let navM = UINavigationController(rootViewController: tabM)
        navM.isNavigationBarHidden = true
        tabVC.viewControllers = [navP, navF, navM]
        tabVC.selectedIndex = index
        return tabVC
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        print("applicationWillResignActive")
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("applicationDidEnterBackground")
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        print("applicationWillEnterForeground")
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        print("applicationDidBecomeActive")
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        print("applicationWillTerminate")
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
//        if viewControllerOrientation == 1 {
//            return .landscapeLeft
//        } else if viewControllerOrientation == 2 {
//            return .landscapeRight
//        }else{
//            return .portrait
//        }
        return deviceOrientation
    }
}
