//
//  DocumentVC.swift
//  EasyEnglish
//
//  Created by Anh Dũng on 1/31/19.
//  Copyright © 2019 Anh Dũng. All rights reserved.
//

import UIKit

class DocumentVC: BaseVC {

    @IBOutlet weak var navi: NavigationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }


}

extension DocumentVC {
    func initUI() {
        navi.title = "txt_document".localized.uppercased()
        
        navi.handleProfile = {
            self.openProfile()
        }
        
        navi.handleSetting = {
            self.openSetting()
        }
    }
}
