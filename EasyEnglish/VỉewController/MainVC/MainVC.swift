//
//  MainVC.swift
//  EasyEnglish
//
//  Created by Anh Dũng on 12/29/18.
//  Copyright © 2018 Anh Dũng. All rights reserved.
//

import UIKit

class MainVC: BaseVC {

    @IBOutlet weak var tableView: UITableView!
    
    var viewModel = ListModelView()

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }

}
extension MainVC {
    func initUI(){
        tableView.register(VideoHomeCell.self)
        tableView.delegate = viewModel
        tableView.dataSource = viewModel
        
        viewModel.handleSelectRow = { (index) in
            
//            TAppDelegate.initPlayVC()
//            self.showZoomOutView()
            
            if !TAppDelegate.isShowZoomOutView {
                //Loadvideo o ngoai main
                
            }else{
                let vc = PlayVC(nibName: "PlayVC", bundle: nil)
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
