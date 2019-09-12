//
//  AboutAppVC.swift
//  EasyEnglish
//
//  Created by Anh Dũng on 8/12/19.
//  Copyright © 2019 Anh Dũng. All rights reserved.
//

import UIKit

class AboutAppVC: BaseVC {

    @IBOutlet weak var navi: NavigationView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navi.handleBack = {
            self.clickBack()
        }
    }
    
    
}
