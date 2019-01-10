//
//  FavoritesVC.swift
//  EasyEnglish
//
//  Created by Anh Dũng on 1/4/19.
//  Copyright © 2019 Anh Dũng. All rights reserved.
//

import UIKit

class FavoritesVC: BaseVC {
    @IBOutlet weak var viewToolReight: UIView!
    @IBOutlet weak var viewToolLeft: UIView!
    @IBOutlet weak var toolBar: ToolBarView!
    @IBOutlet weak var navi: NavigationView!
    
    var swicthView = false {
        didSet {
            if swicthView {
                viewToolLeft.isHidden = true
                viewToolReight.isHidden = false
            }else{
                viewToolLeft.isHidden = false
                viewToolReight.isHidden = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        initData()
    }
    
}

extension FavoritesVC {
    func initUI() {
        navi.title = ""
        toolBar.handleActionG2Left = {
            self.swicthView = false
        }
        
        toolBar.handleActionG2Right = {
            self.swicthView = true
        }
    }
    
    func initData() {
        
    }
}
