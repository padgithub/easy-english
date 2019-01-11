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
    var idVideoPlaying = ""
    var arrVideoPlaying = [Items]()
    var indexPlaying = 0
    var titleCatagory = ""
    var titlePlaylist = ""
    var handleReloadDataNotes: (() -> Void)?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        youtubeShare.turnAudio()
        configSQL()
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: "HelveticaNeue", size: 12) as Any, NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        UITabBar.appearance().unselectedItemTintColor = UIColor("9D271B", alpha: 1.0)
        UITabBar.appearance().tintColor = UIColor.white
        
        initMainVC()
        return true
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

extension AppDelegate {
    func configSQL() {
        if UserDefaults.standard.bool(forKey: "MOVE_FILE1.2") != true {
            UserDefaults.standard.set(true, forKey: "MOVE_FILE1.2")
            UserDefaults.standard.synchronize()
        
            let fileManager = FileManager.default
            let destinationSqliteURL = GroupManager.database
            if fileManager.fileExists(atPath: destinationSqliteURL.path) {
                do {
                    try fileManager.removeItem(atPath: destinationSqliteURL.path)
                } catch {
                    print("Could not clear temp folder: \(error)")
                }
            }
            
            let sourceSqliteURL = Bundle.main.path(forResource: "database", ofType: "db")
            
            if !fileManager.fileExists(atPath: destinationSqliteURL.path) {
                // var error:NSError? = nil
                do {
                    try fileManager.copyItem(at: URL.init(fileURLWithPath:sourceSqliteURL!), to: destinationSqliteURL)
                    print("Copied")
                    print(destinationSqliteURL.path)
                } catch let error as NSError {
                    print("Unable to create database \(error.debugDescription)")
                }
            }
        }
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
        let tabP = HomeVC(nibName:"HomeVC",bundle: nil)
        tabP.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "ic_bb_home")!.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "ic_bb_home")!.withRenderingMode(.alwaysOriginal))
        let navP = UINavigationController(rootViewController: tabP)
        navP.isNavigationBarHidden = true
        
        let tabT = ContentListVC(nibName:"ContentListVC",bundle: nil)
        tabT.tabBarItem = UITabBarItem(title: "Catagorys", image: UIImage(named: "ic_bb_trengding")!.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "ic_bb_trengding")!.withRenderingMode(.alwaysOriginal))
        let navT = UINavigationController(rootViewController: tabT)
        navT.isNavigationBarHidden = true
        
        let tabF = FavoritesVC(nibName:"FavoritesVC",bundle: nil)
        tabF.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(named: "ic_bb_sub")!.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "ic_bb_sub")!.withRenderingMode(.alwaysOriginal))
        let navF = UINavigationController(rootViewController: tabF)
        navF.isNavigationBarHidden = true
        
        let tabM = TrendingVC(nibName:"TrendingVC",bundle: nil)
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
    
}
