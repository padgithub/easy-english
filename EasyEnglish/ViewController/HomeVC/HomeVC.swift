//
//  HomeVC.swift
//  EasyEnglish
//
//  Created by Anh Dũng on 1/4/19.
//  Copyright © 2019 Anh Dũng. All rights reserved.
//

import UIKit
import DGElasticPullToRefresh

class HomeVC: BaseVC {

    @IBOutlet weak var navi: NavigationView!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel = ListModelView()
    var arrData = [Items]()
    //    private let animations = [AnimationType.from(direction: .bottom, offset: 30.0)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        initData()
    }
    
    deinit {
        tableView.dg_removePullToRefresh()
    }
}

extension HomeVC {
    func initUI(){
        navi.title = "app_name".localized.uppercased()
        navi.handleProfile = {
            self.openProfile()
        }
        navi.handleSetting = {
            self.openSetting()
        }
        tableView.register(VideoHomeCell.self)
        tableView.delegate = viewModel
        tableView.dataSource = viewModel
        tableView.addInfiniteScrolling {
            self.loadData()
            self.tableView.reloadData()
            self.tableView.infiniteScrollingView.stopAnimating()
        }
        viewModel.handleSelectRow = { (index) in
            let arrTemp = VideoManager.shareInstance.fetchAllForPlaylistId(playlistId: self.arrData[index].playlistId)
            let developer = self.arrData[index].subTitle
            let array = developer.components(separatedBy: " / ")
            TAppDelegate.titlePlaylist = array[1]
            TAppDelegate.titleCatagory = array[0]
            TAppDelegate.idVideoPlaying = self.arrData[index].id
            TAppDelegate.arrVideoPlaying = arrTemp
            TAppDelegate.titleZoomView = self.arrData[index].snippet.title
            
            if !TAppDelegate.isShowZoomOutView {
                viewYoutubePlayer.loadVideoID(TAppDelegate.idVideoPlaying)
            }else{
                let vc = localDataShared.playVC
                TAppDelegate.isNew = true
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            for i in arrTemp.indices {
                if self.arrData[index].id == arrTemp[i].id {
                    TAppDelegate.indexPlaying = i
                }
            }
            self.tableView.deselectRow(at: IndexPath(row: index, section: 0), animated: true)
            self.insertHistory()
        }
        
        viewModel.handleMoreOptionCell = { (item) in
            let title = VideoManager.shareInstance.checkFavorited(videoId: item.id) ? "txt_remove_fa_video".localized : "txt_add_fa_video".localized
            _ = UIAlertController.present(style: .actionSheet, title: "txt_select_action".localized, message: nil, attributedActionTitles: [(title, .default), ("txt_share".localized, .default),("txt_report".localized, .default), ("txt_cancel".localized, .cancel)], handler: { (action) in
                if action.title == "txt_add_fa_video".localized {
                    self.addFavorite(item)
                }
                if action.title == "txt_remove_fa_video".localized {
                    self.removeFavorite(item)
                }
                if action.title == "txt_share".localized {
                    self.share(item)
                }
                if action.title == "txt_report".localized {
                    self.report(item)
                }
            })
        }
        
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        
        loadingView.tintColor = UIColor(red: 78/255.0, green: 221/255.0, blue: 200/255.0, alpha: 1.0)
        
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1.2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                self!.refresh()
            })
            }, loadingView: loadingView)
        
        tableView.dg_setPullToRefreshFillColor(UIColor(red: 57/255.0, green: 67/255.0, blue: 89/255.0, alpha: 1.0))
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
        AppUpdate.shared.delegate = self
        AppUpdate.shared.showUpdateWithConfirmation()
    }
    
    func refresh() {
        self.arrData.removeAll()
        initData()
        tableView.reloadData()
        //        animate()
        tableView.dg_stopLoading()
    }
    
    func loadData() {
        let arr = VideoManager.shareInstance.fetchVideoListDBRanDom()
        self.arrData.append(contentsOf: arr)
        viewModel.arrData = self.arrData
        print(self.arrData.count)
    }
    
    func initData() {
        loadData()
        tableView.reloadData()
    }
    //    func animate() {
    //        // Combined animations example
    //        let fromAnimation = AnimationType.from(direction: .right, offset: 30.0)
    //        let zoomAnimation = AnimationType.zoom(scale: 0.2)
    ////        let rotateAnimation = AnimationType.rotate(angle: CGFloat.pi/6)
    ////        UIView.animate(views: collectionView.visibleCells,
    ////                       animations: [zoomAnimation, rotateAnimation],
    ////                       duration: 0.5)
    //
    //        UIView.animate(views: tableView.visibleCells,
    //                       animations: [fromAnimation, zoomAnimation], delay: 0.5)
    //    }
}

extension HomeVC: AppUpdateDelegate {
    func appUpdaterDidShowUpdateDialog() {
        print("appUpdaterDidShowUpdateDialog")
    }
    
    func appUpdaterUserDidCancel() {
        print("appUpdaterUserDidCancel")
//        if hasAutoLogin {
//            self.login()
//        }
    }
    
    func appUpdaterUserDidLaunchAppStore() {
        print("appUpdaterUserDidLaunchAppStore")
    }
    
    func appUpdaterHaveNotUpdate() {
        print("appUpdaterHaveNotUpdate")
//        if hasAutoLogin {
//            self.login()
//        }
    }
}
