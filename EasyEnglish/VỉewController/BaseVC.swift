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
        if TAppDelegate.isPlay && !TAppDelegate.isShowZoomOutView {
            zoomOutView.addSubViewVideo()
            VideoServiceView.shared.viewPlayer.play()
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

