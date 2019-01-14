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
        tableView.register(VideoHomeCell.self)
        tableView.delegate = viewModel
        tableView.dataSource = viewModel
        
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
                let vc = PlayVC(nibName: "PlayVC", bundle: nil)
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
        
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        
        loadingView.tintColor = UIColor(red: 78/255.0, green: 221/255.0, blue: 200/255.0, alpha: 1.0)
        
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1.2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                self!.refresh()
            })
            }, loadingView: loadingView)
        
        tableView.dg_setPullToRefreshFillColor(UIColor(red: 57/255.0, green: 67/255.0, blue: 89/255.0, alpha: 1.0))
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
    }
    
    func refresh() {
        initData()
        tableView.reloadData()
        //        animate()
        tableView.dg_stopLoading()
    }
    
    func loadData() {
        self.arrData.removeAll()
        self.arrData = VideoManager.shareInstance.fetchVideoListDBRanDom()
    }
    
    func initData() {
        loadData()
        viewModel.arrData = self.arrData
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

