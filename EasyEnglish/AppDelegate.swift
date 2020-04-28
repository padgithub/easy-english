//
//  AppDelegate.swift
//  EasyEnglish
//
//  Created by Anh Dũng on 12/28/18.
//  Copyright © 2018 Anh Dũng. All rights reserved.
//

import UIKit
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var menuContainerViewController: MFSideMenuContainerViewController? = nil
    var tabVC: UITabBarController?
    
    var isShowZoomOutView = true
    var isPlay = false
    var isNew = false
    var deviceOrientation = UIInterfaceOrientationMask.portrait
    var handleReturnForeground: (() -> Void)?
    var idVideoPlaying = ""
    var isAutoPlay = false
    var arrVideoPlaying = [Items]()
    var indexPlaying = 0
    var titleCatagory = ""
    var titlePlaylist = ""
    var titleZoomView = ""
    var handleReloadDataNotes: (() -> Void)?
    var handleReturnView: (() -> Void)?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print(FilePaths.VidToLive.livePath)
        //        FBSDKApplicationDelegate.sharedInstance()?.application(application, didFinishLaunchingWithOptions: launchOptions)
        //Config Admob
        GADMobileAds.sharedInstance().start { (status) in
            
        }
        AdmobManager.shared.fullRootViewController = (self.window?.rootViewController)!
        //
        youtubeShare.turnAudio()
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: "HelveticaNeue", size: 12) as Any, NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        UITabBar.appearance().unselectedItemTintColor = UIColor("9D271B", alpha: 1.0)
        UITabBar.appearance().tintColor = UIColor.white
        configSQL()
        checkUpdateDB()
        //        initMenu()
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        //        let handle = FBSDKApplicationDelegate.sharedInstance()?.application(app, open: url, options: options)
        //        return handle!
        // Determine who sent the URL.
        let sendingAppID = options[.sourceApplication]
        print("source application = \(sendingAppID ?? "Unknown")")
        
        // Process the URL.
        guard let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true),
            let albumPath = components.path,
            let params = components.queryItems else {
                print("Invalid URL or album path missing")
                return false
        }
        
        if let photoIndex = params.first(where: { $0.name == "index" })?.value {
            print("albumPath = \(albumPath)")
            print("photoIndex = \(photoIndex)")
            return true
        } else {
            print("Photo index missing")
            return false
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        print("applicationWillResignActive")
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        youtubeShare.handlePlayWhenPause = {
            Timer.every(0.001) {
                if self.isPlay {
                    viewYoutubePlayer.playVideo()
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
            let destinationSqliteURLHistory = HistoryManger.database
            let destinationSqliteURLGiaoTiep = GiaoTiepManger.database
            let destinationSqliteURLKanji = KanjiManager.database
            let destinationSqliteURLNhatViet = NhatVietManager.database
            let destinationSqliteURLVietNhat = VietNhatManager.database
            let destinationSqliteURLNguPhap = NguPhapManager.database
            
            if fileManager.fileExists(atPath: destinationSqliteURL.path) {
                do {
                    try fileManager.removeItem(atPath: destinationSqliteURL.path)
                } catch {
                    print("Could not clear temp folder: \(error)")
                }
            }
            
            if fileManager.fileExists(atPath: destinationSqliteURLHistory.path) {
                do {
                    try fileManager.removeItem(atPath: destinationSqliteURLHistory.path)
                } catch {
                    print("Could not clear temp folder: \(error)")
                }
            }
            
            if fileManager.fileExists(atPath: destinationSqliteURLGiaoTiep.path) {
                do {
                    try fileManager.removeItem(atPath: destinationSqliteURLGiaoTiep.path)
                } catch {
                    print("Could not clear temp folder: \(error)")
                }
            }
            
            if fileManager.fileExists(atPath: destinationSqliteURLKanji.path) {
                do {
                    try fileManager.removeItem(atPath: destinationSqliteURLKanji.path)
                } catch {
                    print("Could not clear temp folder: \(error)")
                }
            }
            
            if fileManager.fileExists(atPath: destinationSqliteURLNhatViet.path) {
                do {
                    try fileManager.removeItem(atPath: destinationSqliteURLKanji.path)
                } catch {
                    print("Could not clear temp folder: \(error)")
                }
            }
            
            if fileManager.fileExists(atPath: destinationSqliteURLVietNhat.path) {
                do {
                    try fileManager.removeItem(atPath: destinationSqliteURLKanji.path)
                } catch {
                    print("Could not clear temp folder: \(error)")
                }
            }
            
            if fileManager.fileExists(atPath: destinationSqliteURLNguPhap.path) {
                do {
                    try fileManager.removeItem(atPath: destinationSqliteURLKanji.path)
                } catch {
                    print("Could not clear temp folder: \(error)")
                }
            }
            
            let sourceSqliteURL = Bundle.main.path(forResource: "database", ofType: "db")
            let sourceSqliteURLHistory = Bundle.main.path(forResource: "history", ofType: "db")
            let sourceSqliteURLGiaoTiep = Bundle.main.path(forResource: "giaotiep", ofType: "sqlite")
            let sourceSqliteURLKanji = Bundle.main.path(forResource: "kanji", ofType: "db")
            let sourceSqliteURLNhatViet = Bundle.main.path(forResource: "jpn_vie", ofType: "db")
            let sourceSqliteURLVietNhat = Bundle.main.path(forResource: "vie_jpn", ofType: "db")
            let sourceSqliteURLNguPhap = Bundle.main.path(forResource: "grammar", ofType: "db")
            
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
            
            if !fileManager.fileExists(atPath: destinationSqliteURLHistory.path) {
                // var error:NSError? = nil
                do {
                    try fileManager.copyItem(at: URL.init(fileURLWithPath:sourceSqliteURLHistory!), to: destinationSqliteURLHistory)
                    print("Copied")
                    print(destinationSqliteURLHistory.path)
                } catch let error as NSError {
                    print("Unable to create database \(error.debugDescription)")
                }
            }
            
            if !fileManager.fileExists(atPath: destinationSqliteURLGiaoTiep.path) {
                // var error:NSError? = nil
                do {
                    try fileManager.copyItem(at: URL.init(fileURLWithPath:sourceSqliteURLGiaoTiep!), to: destinationSqliteURLGiaoTiep)
                    print("Copied")
                    print(destinationSqliteURLGiaoTiep.path)
                } catch let error as NSError {
                    print("Unable to create database \(error.debugDescription)")
                }
            }
            
            if !fileManager.fileExists(atPath: destinationSqliteURLKanji.path) {
                // var error:NSError? = nil
                do {
                    try fileManager.copyItem(at: URL.init(fileURLWithPath:sourceSqliteURLKanji!), to: destinationSqliteURLKanji)
                    print("Copied")
                    print(destinationSqliteURLKanji.path)
                } catch let error as NSError {
                    print("Unable to create database \(error.debugDescription)")
                }
            }
            
            if !fileManager.fileExists(atPath: destinationSqliteURLNhatViet.path) {
                // var error:NSError? = nil
                do {
                    try fileManager.copyItem(at: URL.init(fileURLWithPath:sourceSqliteURLNhatViet!), to: destinationSqliteURLNhatViet)
                    print("Copied")
                    print(destinationSqliteURLNhatViet.path)
                } catch let error as NSError {
                    print("Unable to create database \(error.debugDescription)")
                }
            }
            
            if !fileManager.fileExists(atPath: destinationSqliteURLVietNhat.path) {
                // var error:NSError? = nil
                do {
                    try fileManager.copyItem(at: URL.init(fileURLWithPath:sourceSqliteURLVietNhat!), to: destinationSqliteURLVietNhat)
                    print("Copied")
                    print(destinationSqliteURLVietNhat.path)
                } catch let error as NSError {
                    print("Unable to create database \(error.debugDescription)")
                }
            }
            
            if !fileManager.fileExists(atPath: destinationSqliteURLNguPhap.path) {
                // var error:NSError? = nil
                do {
                    try fileManager.copyItem(at: URL.init(fileURLWithPath:sourceSqliteURLNguPhap!), to: destinationSqliteURLNguPhap)
                    print("Copied")
                    print(destinationSqliteURLKanji.path)
                } catch let error as NSError {
                    print("Unable to create database \(error.debugDescription)")
                }
            }
        }
    }
    
    
    func checkUpdateDB() {
        let dbShared = DBManager()
        dbShared.checkDB { (bool) in
            if bool {
                if !(SaveHelper.get(.downloadSuccessDB) as? Bool ?? false ) {
                    dbShared.downloadDB(success: { (xong) in
                        if xong {
                            SaveHelper.save(true, key: .downloadSuccessDB)
                            self.initMenu()
                        }else{
                            SaveHelper.save(false, key: .downloadSuccessDB)
                            _ = TAppDelegate.window?.rootViewController?.presentAlert(style: .alert, title: "txt_restart_app", message: "txt_restart_app_msg_error", actionTitles: ["txt_oke".localized], handler: { (action) in
                                if action.title == "txt_oke".localized {
                                    exit(0)
                                }
                            })
                        }
                    })
                }else{
                    self.initMenu()
                }
            }else{
                self.initMenu()
                SaveHelper.save(false, key: .downloadSuccessDB)
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
    
    func initPlayVC() -> UINavigationController  {
        let vc = PlayVC(nibName: "PlayVC",bundle: nil)
        let nav = UINavigationController(rootViewController: vc)
        nav.isNavigationBarHidden = true
        return nav
    }
    
    func initTabVC(_ index: Int) -> UITabBarController{
        if let tab = tabVC {
            tab.selectedIndex = index
        } else {
            tabVC = UITabBarController()
            tabVC?.tabBar.barTintColor = UIColor.clear
            tabVC?.tabBar.backgroundImage = nil
            tabVC?.tabBar.shadowImage = nil
            tabVC?.tabBar.layer.borderWidth = 0.0
            tabVC?.tabBar.clipsToBounds = true
            tabVC?.tabBar.contentMode = .scaleToFill
            tabVC?.tabBar.isTranslucent = false
            //
            let tabP = HomeVC(nibName:"HomeVC",bundle: nil)
            tabP.tabBarItem = UITabBarItem(title: "txt_home".localized, image: UIImage(named: "ic_bb_home")!.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "ic_bb_home")!.withRenderingMode(.alwaysOriginal))
            let navP = UINavigationController(rootViewController: tabP)
            navP.isNavigationBarHidden = true
            
            let tabT = ContentListVC(nibName:"ContentListVC",bundle: nil)
            tabT.tabBarItem = UITabBarItem(title: "txt_catalogue".localized, image: UIImage(named: "ic_bb_trengding")!.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "ic_bb_trengding")!.withRenderingMode(.alwaysOriginal))
            let navT = UINavigationController(rootViewController: tabT)
            navT.isNavigationBarHidden = true
            
            let tabF = TuDienVC(nibName:"TuDienVC",bundle: nil)
            tabF.tabBarItem = UITabBarItem(title: "txt_tudien".localized, image: UIImage(named: "ic_bb_favorite")!.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "ic_bb_favorite")!.withRenderingMode(.alwaysOriginal))
            let navF = UINavigationController(rootViewController: tabF)
            navF.isNavigationBarHidden = true
            
            let tabM = GiaoTiepCoBanVC(nibName:"GiaoTiepCoBanVC",bundle: nil)
            tabM.tabBarItem = UITabBarItem(title: "txt_giaotiep".localized, image: UIImage(named: "tab_radio_menu")!.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "tab_radio_menu")!.withRenderingMode(.alwaysOriginal))
            let navM = UINavigationController(rootViewController: tabM)
            navM.isNavigationBarHidden = true
            
            let tabL = LibraryVC(nibName:"LibraryVC",bundle: nil)
            tabL.tabBarItem = UITabBarItem(title: "txt_library".localized, image: UIImage(named: "ic_bb_libray")!.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "ic_bb_libray")!.withRenderingMode(.alwaysOriginal))
            let navL = UINavigationController(rootViewController: tabL)
            navL.isNavigationBarHidden = true
            
            tabVC?.viewControllers = [navP, navT, navF, navM, navL]
            tabVC?.selectedIndex = index
        }
        return tabVC!
    }
}


extension AppDelegate {
    func initMenu() {
        let tab = initTabVC(0)
        let menuVC = MenuVC(nibName: "MenuVC", bundle: nil)
        let homeVC = HomeVC.init()
        let navi = UINavigationController(rootViewController: homeVC)
        navi.isNavigationBarHidden = true
        menuContainerViewController  = MFSideMenuContainerViewController.container(withCenter: tab,
                                                                                   leftMenuViewController: menuVC,  rightMenuViewController: nil)
        self.window?.rootViewController = menuContainerViewController
    }
}
