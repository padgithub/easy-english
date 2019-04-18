//
//  ProfileVC.swift
//  EasyEnglish
//
//  Created by Anh Dũng on 1/31/19.
//  Copyright © 2019 Anh Dũng. All rights reserved.
//

import UIKit
import SwiftyJSON

class ProfileVC: BaseVC, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var loginButton: FBSDKLoginButton!
    @IBOutlet weak var imageBg: UIImageView!
    @IBOutlet weak var lbFullName: UILabel!
    @IBOutlet weak var imageAvatar: KHImageView!
    @IBOutlet weak var navi: NavigationView!

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        initFB()
    }
}

extension ProfileVC {
    func initFB() {
        loginButton.readPermissions = ["public_profile","email"]
        loginButton.delegate = self
        if let token = FBSDKAccessToken.current() {
            print(token)
            getProfile()
        }
    }
    func initUI() {
        navi.imageBackground.image = nil
        navi.handleBack = {
            self.popBack()
        }
        
        if let name = SaveHelper.get(.fbName) as? String, name != "" {
            lbFullName.text = name
        }else{
            lbFullName.text = "app_name".localized
        }
        
        if let image = SaveHelper.get(.fbImage) as? String, image != "" {
            imageAvatar.downloaded(from: image)
            imageBg.downloaded(from: image)
        }else{
            imageAvatar.image = navi.randomAvatar()
        }
    }
    
    func popBack() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func getProfile() {
        let parameters = ["fields":"email,name,picture.type(large)"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameters)?.start(completionHandler: { (conection, result, err) in
            let json = JSON(result as Any)
            let name = json["name"].stringValue
            SaveHelper.save(name, key: .fbName)
            let url = json["picture"]["data"]["url"].stringValue
            SaveHelper.save(url, key: .fbImage)
            self.initUI()
        })
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        getProfile()
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        SaveHelper.save("", key: .fbImage)
        SaveHelper.save("", key: .fbName)
        initUI()
    }
}
extension ProfileVC : WKUIDelegate, WKNavigationDelegate, UIWebViewDelegate {
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame?.isMainFrame == nil {
            webView.load(navigationAction.request)
        }
        return nil
    }
}

