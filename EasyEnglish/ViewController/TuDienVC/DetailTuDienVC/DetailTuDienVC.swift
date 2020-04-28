//
//  DetailTuDienVC.swift
//  EasyJapanese
//
//  Created by Phung Anh Dung on 4/27/20.
//  Copyright © 2020 Anh Dũng. All rights reserved.
//

import UIKit

class DetailTuDienVC: BaseVC {

    @IBOutlet weak var navi: NavigationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navi.handleBack = {
            self.clickBack()
        }
    }
}
