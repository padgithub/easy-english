//
//  ListVideoVC.swift
//  EasyEnglish
//
//  Created by Anh Dũng on 1/5/19.
//  Copyright © 2019 Anh Dũng. All rights reserved.
//

import UIKit

class ListVideoVC: BaseVC {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navi: NavigationView!
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        initData()
    }
}

extension ListVideoVC {
    func initUI() {
        navi.handleLeft = {
            self.clickBack()
        }
    }
    
    func initData() {
    
    }
}
