//
//  MainVC.swift
//  EasyEnglish
//
//  Created by Anh Dũng on 12/29/18.
//  Copyright © 2018 Anh Dũng. All rights reserved.
//

import UIKit
import DGElasticPullToRefresh

class MainVC: BaseVC {

    @IBOutlet weak var tableView: UITableView!
    
    var viewModel = ListModelView()
//    private let animations = [AnimationType.from(direction: .bottom, offset: 30.0)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    deinit {
        tableView.dg_removePullToRefresh()
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
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        
        loadingView.tintColor = UIColor(red: 78/255.0, green: 221/255.0, blue: 200/255.0, alpha: 1.0)
        
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                self!.refresh()
            })
            }, loadingView: loadingView)
        
        tableView.dg_setPullToRefreshFillColor(UIColor(red: 57/255.0, green: 67/255.0, blue: 89/255.0, alpha: 1.0))
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
    }
    
    func refresh() {
        tableView.reloadData()
//        animate()
        tableView.dg_stopLoading()
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
