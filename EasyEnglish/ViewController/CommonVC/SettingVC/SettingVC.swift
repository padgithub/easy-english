//
//  SettingVC.swift
//  EasyEnglish
//
//  Created by Anh Dũng on 1/26/19.
//  Copyright © 2019 Anh Dũng. All rights reserved.
//

import UIKit

class SettingVC: BaseVC {

    @IBOutlet weak var lbVersion: KHLabel!
    @IBOutlet weak var lbLanguege: KHLabel!
    @IBOutlet weak var imgFlags: UIImageView!
    @IBOutlet weak var imgCheckbox: UIImageView!
    @IBOutlet weak var navi: NavigationView!
    
    let arrLag = LanguageManager.shared.availableLocales
    
    var isUsingToolBarSystem = false {
        didSet{
            imgCheckbox.image = isUsingToolBarSystem ? UIImage(named: "ic_auto_play_on") : UIImage(named: "ic_auto_play_off")
        }
    }
    
    var flags = CustomLocale(languageCode: GlobalConstants.englishCode.rawValue, countryCode: "gb", name: "United Kingdom") {
        didSet{
            lbLanguege.text = flags.name
            imgFlags.image = UIImage(named: flags.countryCode!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        initData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        isUsingToolBarSystem = UserDefaults.standard.bool(forKey: "TOOLBARPLAY")
    }
    
    @IBAction func actionButtom(_ sender: UIButton) {
        switch sender.tag {
        case 21:
            isUsingToolBarSystem = !isUsingToolBarSystem
            UserDefaults.standard.set(isUsingToolBarSystem, forKey: "TOOLBARPLAY")
            UserDefaults.standard.synchronize()
            allwayRestartApp()
            break
        case 22:
            changeLanguage()
            break
        case 23:
            if let url = URL(string: "mailto:\(Contansts.myMailContact)") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            break
        case 24:
            //Set the default sharing message.
            let message = "Message goes here."
            //Set the link to share.
            if let link = NSURL(string: "http://yoururl.com")
            {
                let objectsToShare = [message,link] as [Any]
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
                self.present(activityVC, animated: true, completion: nil)
            }
            break
        case 25:
            //Rate
            AppStoreReviewManager.requestReviewNow()
            break
        case 26:
            let vc = AboutAppVC(nibName: "AboutAppVC", bundle: nil)
            self.navigationController?.pushViewController(vc, animated: true)
            break
        default:
            break
        }
    }
    
}

extension SettingVC {
    func initUI() {
        navi.handleBack = {
            self.clickBack()
        }
        
        for i in arrLag {
            if i.languageCode == LanguageManager.shared.lprojBasePath {
                flags = i
                return
            }
        }
        
        let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
        lbVersion.text = "v\(appVersion ?? "1.0.0")"
    }
    
    func initData() {
        
    }
    
    func changeLanguage() {
        _ = presentAlert(style: .actionSheet, title: "txt_st_lg".localized, message: "txt_select_language".localized, actionTitles: [arrLag[0].name!,arrLag[1].name!,"txt_cancel".localized], handler: { (action) in
            if action.title == self.arrLag[0].name! {
                LanguageManager.shared.setLocale(self.arrLag[0].languageCode!)
                self.flags = self.arrLag[0]
                self.restartApp()
            }
            if action.title == self.arrLag[1].name! {
                LanguageManager.shared.setLocale(self.arrLag[1].languageCode!)
                self.flags = self.arrLag[1]
                self.restartApp()
            }
        })
    }
    
    func restartApp() {
        _ = self.presentAlert(style: .alert, title: "txt_restart_app", message: "txt_restart_app_msg", actionTitles: ["txt_oke".localized,"txt_cancel".localized], handler: { (action) in
            if action.title == "txt_oke".localized {
                exit(0)
            }
        })
    }
    
    func allwayRestartApp() {
        _ = self.presentAlert(style: .alert, title: "txt_restart_app", message: "txt_restart_app_msg", actionTitles: ["txt_oke".localized], handler: { (action) in
            if action.title == "txt_oke".localized {
                exit(0)
            }
        })
    }
}
