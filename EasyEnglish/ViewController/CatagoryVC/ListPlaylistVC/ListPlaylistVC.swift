//
//  ListPlaylistVC.swift
//  EasyEnglish
//
//  Created by Anh Dũng on 1/5/19.
//  Copyright © 2019 Anh Dũng. All rights reserved.
//

import UIKit

class ListPlaylistVC: BaseVC {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navi: NavigationView!
    
    var viewModel = ListModelPlaylistView()
    var arrData = [Playlist]()
    var catagoryId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        loadData()
        initData()
    }
}

extension ListPlaylistVC {
    func initUI() {
        navi.handleLeft = {
            self.clickBack()
        }
        tableView.register(VideoPlayCell.self)
        tableView.delegate = viewModel
        tableView.dataSource = viewModel
        viewModel.handleSelectRow = { (index) in
            let vc = ListVideoVC(nibName: "ListVideoVC",bundle: nil)
            vc.playlist = self.arrData[index]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func initData() {
        viewModel.arrData = arrData
    }
    
    func loadData() {
        arrData = PlaylistManager.shareInstance.fetchPlayList(category_id: catagoryId)
    }
}
