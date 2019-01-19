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
    var categories = Category()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        loadData()
        initData()
    }
}

extension ListPlaylistVC {
    func initUI() {
        navi.title = categories.name
        
        navi.handleBack = {
            self.clickBack()
        }
        tableView.register(VideoPlayCell.self)
        tableView.delegate = viewModel
        tableView.dataSource = viewModel
        viewModel.handleSelectRow = { (index) in
            let vc = ListVideoVC(nibName: "ListVideoVC",bundle: nil)
            vc.playlist = self.arrData[index]
            vc.categories = self.categories
            self.navigationController?.pushViewController(vc, animated: true)
            TAppDelegate.titleCatagory = self.categories.name
            self.tableView.deselectRow(at: IndexPath(row: index, section: 0), animated: true)
        }
        viewModel.handleMoreOption = { (item) in
            let title = PlaylistManager.shareInstance.checkFavorite(playlist: item) ? "txt_remove_fa_playlist".localized : "txt_add_fa_playlist".localized
            _ = UIAlertController.present(style: .actionSheet, title: "txt_select_action".localized, message: nil, attributedActionTitles: [(title, .default), ("txt_share".localized, .default), ("txt_cancel".localized, .cancel)], handler: { (action) in
                if action.title == "txt_add_fa_playlist".localized {
                    self.addFavorite(item)
                }
                if action.title == "txt_remove_fa_playlist".localized {
                    self.removeFavorite(item)
                }
                if action.title == "txt_share".localized {
                    self.share(item)
                }
            })
        }
    }
    
    func initData() {
        viewModel.arrData = arrData
    }
    
    func loadData() {
        arrData = PlaylistManager.shareInstance.fetchPlayList(category_id: categories.group_id)
    }
}
