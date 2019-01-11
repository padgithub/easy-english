//
//  BaseVC.swift
//  Real Estate
//
//  Created by Hoa on 12/22/18.
//  Copyright © 2018 Hoa. All rights reserved.
//

import UIKit

let kBarHeight = (DeviceType.IS_IPHONE_X) ? 84 : 50

class BaseVC: UIViewController {
    
    var zoomOutView = ZoomOutViewPlayVideo()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.background()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.initZoomOutView()
        zoomOutView.isPlay = TAppDelegate.isPlay
        if !TAppDelegate.isShowZoomOutView {
            zoomOutView.addSubViewVideo()
            if TAppDelegate.isPlay {
                viewYoutubePlayer.play()
            }
        }
    }
    
}

extension BaseVC {
    
    func initZoomOutView() {
        zoomOutView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(zoomOutView)
        
        zoomOutView.leadingAnchor.constraint(equalTo: (TAppDelegate.window?.leadingAnchor)!, constant: 5).isActive = true
        zoomOutView.trailingAnchor.constraint(equalTo: (TAppDelegate.window?.trailingAnchor)!, constant: -5).isActive = true
        
        zoomOutView.bottomAnchor.constraint(equalTo: (TAppDelegate.window?.bottomAnchor)!, constant: CGFloat(-5 - kBarHeight) ).isActive = true
        zoomOutView.heightAnchor.constraint(equalToConstant: 85*heightRatio)
        
        zoomOutView.handleReturnView = {
            self.removeZoomOutView()
            let vc = PlayVC(nibName: "PlayVC", bundle: nil)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        zoomOutView.handleRemoveView = {
            self.removeZoomOutView()
        }
        
        zoomOutView.isHidden = TAppDelegate.isShowZoomOutView
    }
    func showZoomOutView() {
        TAppDelegate.isShowZoomOutView = false
        zoomOutView.isPlay = !TAppDelegate.isPlay
        zoomOutView.isHidden = false
    }
    
    func removeZoomOutView() {
        TAppDelegate.isShowZoomOutView = true
        zoomOutView.isHidden = true
    }
    
    func clickBack() {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    func goPlay(arrData: [Items],index: Int) {
        let arrTemp = VideoManager.shareInstance.fetchAllForPlaylistId(playlistId: arrData[index].playlistId)
        let developer = arrData[index].subTitle
        let array = developer.components(separatedBy: " / ")
        TAppDelegate.titlePlaylist = array[1]
        TAppDelegate.titleCatagory = array[0]
        TAppDelegate.idVideoPlaying = arrData[index].id
        TAppDelegate.arrVideoPlaying = arrTemp
        
        self.zoomOutView.lbTitleVideo.text = arrData[index].snippet.title
        
        if !TAppDelegate.isShowZoomOutView {
            viewYoutubePlayer.loadVideoID(TAppDelegate.idVideoPlaying)
        }else{
            let vc = PlayVC(nibName: "PlayVC", bundle: nil)
            TAppDelegate.isNew = true
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        for i in arrTemp.indices {
            if arrData[index].id == arrTemp[i].id {
                TAppDelegate.indexPlaying = i
            }
        }
    }
    
}

extension UITabBarController {
    func background() {
        var tabFrame = tabBar.bounds
        tabFrame.size.height = CGFloat(kBarHeight)
        tabFrame.origin.y = self.view.frame.size.height - CGFloat(kBarHeight)
        tabBar.frame = tabFrame
        let tabBackground = UIImageView(frame: CGRect.init(x: 0, y: 0, width: Int(ScreenSize.SCREEN_WIDTH), height: kBarHeight))
        tabBackground.image = #imageLiteral(resourceName: "bg")
        tabBackground.contentMode = .scaleToFill
        tabBar.insertSubview(tabBackground, at: 0)
    }
}

