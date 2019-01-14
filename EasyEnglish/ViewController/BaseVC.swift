//
//  BaseVC.swift
//  Real Estate
//
//  Created by Anh Dũng on 12/22/18.
//  Copyright © 2018 Hoa. All rights reserved.
//

import UIKit
import SwiftEntryKit

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
        TAppDelegate.handleReturnView = {
            let vc = PlayVC(nibName: "PlayVC", bundle: nil)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            self.removeZoomOutView()
        }
        zoomOutView.handleRemoveView = {
            self.removeZoomOutView()
        }
    }
    
    func insertHistory() {
        let obj = HistoryObj()
        obj.video_id = TAppDelegate.arrVideoPlaying[TAppDelegate.indexPlaying].id
        obj.creatDate = Int(Date().secondsSince1970)
        HistoryManger.shared.insertOrUpdate(obj)
    }
}

extension BaseVC {
    
    func showZoomOutView() {
        showNib()
        TAppDelegate.isShowZoomOutView = false
        zoomOutView.isPlay = !TAppDelegate.isPlay
        zoomOutView.isPlay = TAppDelegate.isPlay
        if !TAppDelegate.isShowZoomOutView {
            zoomOutView.addSubViewVideo()
            if TAppDelegate.isPlay {
                viewYoutubePlayer.play()
            }
        }
        zoomOutView.lbTitleVideo.text = TAppDelegate.titleZoomView
    }
    
    func removeZoomOutView() {
        removeNib()
        TAppDelegate.isPlay = false
        TAppDelegate.isShowZoomOutView = true
    }
    
    func showNib() {
        SwiftEntryKit.display(entry: zoomOutView, using: attributes(), presentInsideKeyWindow: false, rollbackWindow: SwiftEntryKit.RollbackWindow.custom(window: TAppDelegate.window!))
    }
    
    func removeNib() {
        SwiftEntryKit.dismiss()
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
        TAppDelegate.titleZoomView = arrData[index].snippet.title
        
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
        insertHistory()
    }
    
    func attributes() -> EKAttributes {
        var attributes: EKAttributes
        attributes = .bottomFloat
        attributes.hapticFeedbackType = .success
        attributes.displayDuration = 1000000
        attributes.screenBackground = .clear
        attributes.entryBackground = .clear
        attributes.screenInteraction = .forward
        attributes.entryInteraction = .absorbTouches
        
        attributes.entranceAnimation = .init(translate: .init(duration: 0.5, spring: .init(damping: 0.9, initialVelocity: 0)),
                                             scale: .init(from: 0.8, to: 1, duration: 0.5, spring: .init(damping: 0.8, initialVelocity: 0)),
                                             fade: .init(from: 0.7, to: 1, duration: 0.3))
        attributes.exitAnimation = .init(translate: .init(duration: 0.5),
                                         scale: .init(from: 1, to: 0.8, duration: 0.5),
                                         fade: .init(from: 1, to: 0, duration: 0.5))
        attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.3),
                                                            scale: .init(from: 1, to: 0.8, duration: 0.3)))
        attributes.shadow = .active(with: .init(color: .black, opacity: 0.3, radius: 6))
        attributes.positionConstraints.verticalOffset = CGFloat(kBarHeight - 30)
        attributes.positionConstraints.size = .init(width: .offset(value: 5), height: .intrinsic)
        attributes.positionConstraints.maxSize = .init(width: .constant(value: UIScreen.main.minEdge), height: .intrinsic)
        
        attributes.statusBar = .dark
        return attributes
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


extension UIScreen {
    var minEdge: CGFloat {
        return UIScreen.main.bounds.minEdge
    }
}
extension CGRect {
    var minEdge: CGFloat {
        return min(width, height)
    }
}
