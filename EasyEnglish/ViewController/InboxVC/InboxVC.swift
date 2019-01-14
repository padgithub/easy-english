//
//  InboxVC.swift
//  EasyEnglish
//
//  Created by Anh Dũng on 1/4/19.
//  Copyright © 2019 Anh Dũng. All rights reserved.
//

import UIKit


class InboxVC: BaseVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginButton = FBSDKLoginButton()
        loginButton.center = self.view.center;
        loginButton.readPermissions = ["public_profile","email"]
        
        self.view.addSubview(loginButton)
        if let token = FBSDKAccessToken.current() {
            print(token)
        }
    }

}
