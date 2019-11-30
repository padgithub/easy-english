//
//  FavoritesVC.swift
//  EasyEnglish
//
//  Created by Anh Dũng on 1/4/19.
//  Copyright © 2019 Anh Dũng. All rights reserved.
//

import UIKit

class FavoritesVC: BaseVC {
    @IBOutlet weak var tableViewLeft: UITableView!
    @IBOutlet weak var tableViewReight: UITableView!
    @IBOutlet weak var viewToolReight: UIView!
    @IBOutlet weak var viewToolLeft: UIView!
    @IBOutlet weak var toolBar: ToolBarView!
    @IBOutlet weak var navi: NavigationView!
    
    var viewModelList = ListModelPlaylistView()
    var viewModelVideo = ListModelView()
    
    var arrDataList = [Playlist]()
    var arrDataVideo = [Items]()

    
    var swicthView = false {
        didSet {
            if swicthView {
                viewToolLeft.isHidden = true
                viewToolReight.isHidden = false
                loadData()
            }else{
                viewToolLeft.isHidden = false
                viewToolReight.isHidden = true
                loadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        initData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadData()
    }
    
}

extension FavoritesVC {
    func initUI() {
        isShowInterestl = false
        navi.title = "txt_favorites".localized.uppercased()
        navi.handleSetting = {
            self.openSetting()
        }
        navi.handleProfile = {
            self.openProfile()
        }
        toolBar.handleActionG2Left = {
            self.swicthView = false
        }
        
        toolBar.handleActionG2Right = {
            self.swicthView = true
        }
        //
        tableViewLeft.register(VideoPlayCell.self)
        tableViewLeft.delegate = viewModelList
        tableViewLeft.dataSource = viewModelList
        //
        viewModelList.handleSelectRow = { (index) in
            let catogry = CategoryManager.shareInstance.fethchCategory(self.arrDataList[index].categoryId)
            let vc = ListVideoVC(nibName: "ListVideoVC",bundle: nil)
            vc.categories = catogry
            vc.playlist = self.arrDataList[index]
            self.navigationController?.pushViewController(vc, animated: true)
            TAppDelegate.titleCatagory = catogry.name
            self.tableViewLeft.deselectRow(at: IndexPath(row: index, section: 0), animated: true)
        }
        viewModelList.handleMoreOption = {(item) in
            _ = UIAlertController.present(style: .actionSheet, title: "txt_select_action".localized, message: nil, attributedActionTitles: [("txt_remove_fa_playlist".localized, .default), ("txt_share".localized, .default), ("txt_cancel".localized, .cancel)], handler: { (action) in
                if action.title == "txt_remove_fa_playlist".localized {
                    self.removeFavorite(item)
                    self.loadData()
                }
                if action.title == "txt_share".localized {
                    self.share(item)
                }
            })
        }
        //
        tableViewReight.register(VideoPlayCell.self)
        tableViewReight.delegate = viewModelVideo
        tableViewReight.dataSource = viewModelVideo
        viewModelVideo.isPlaylist = true
        viewModelVideo.handleSelectRow = { (index) in
            self.goPlay(arrData: self.arrDataVideo, index: index)
            self.tableViewReight.deselectRow(at: IndexPath(row: index, section: 0), animated: true)
        }
        viewModelVideo.handleMoreOptionCell = { (item) in
            _ = UIAlertController.present(style: .actionSheet, title: "txt_select_action".localized, message: nil, attributedActionTitles: [("txt_remove_fa_video".localized, .default), ("txt_share".localized, .default), ("txt_cancel".localized, .cancel)], handler: { (action) in
                if action.title == "txt_remove_fa_video".localized {
                    self.removeFavorite(item)
                    self.loadData()
                }
                if action.title == "txt_share".localized {
                    self.share(item)
                }
            })
        }
    }
    
    func loadData(){
        if toolBar.indexSelected == 0 {
            loadDataPlayList()
        }else{
            loadDataVideo()
        }
    }
    
    func loadDataPlayList() {
        self.arrDataList = PlaylistManager.shareInstance.fetchPlayListFevorited()
        viewModelList.arrData = self.arrDataList
        tableViewLeft.backgroundColor = self.arrDataList.count == 0 ? UIColor.clear : UIColor.white
        tableViewLeft.reloadData()
    }
    
    func loadDataVideo() {
        self.arrDataVideo = VideoManager.shareInstance.fetchAllFavorited()
        viewModelVideo.arrData = self.arrDataVideo
        tableViewReight.backgroundColor = self.arrDataVideo.count == 0 ? UIColor.clear : UIColor.white
        tableViewReight.reloadData()
    }
    
    func initData() {
        loadData()
    }
}
