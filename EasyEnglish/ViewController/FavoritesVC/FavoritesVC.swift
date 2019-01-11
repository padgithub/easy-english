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
        //
        tableViewReight.register(VideoPlayCell.self)
        tableViewReight.delegate = viewModelVideo
        tableViewReight.dataSource = viewModelVideo
        viewModelVideo.handleSelectRow = { (index) in
            self.goPlay(arrData: self.arrDataVideo, index: index)
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
        tableViewLeft.reloadData()
    }
    
    func loadDataVideo() {
        self.arrDataVideo = VideoManager.shareInstance.fetchAllFavorited()
        viewModelVideo.arrData = self.arrDataVideo
        tableViewLeft.reloadData()
    }
    
    func initData() {
        loadData()
    }
}
