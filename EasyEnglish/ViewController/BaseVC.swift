//
//  BaseVC.swift
//  Real Estate
//
//  Created by Anh Dũng on 12/22/18.
//  Copyright © 2018 Hoa. All rights reserved.
//

import UIKit
import SwiftEntryKit
//import FBAudienceNetwork

let kBarHeight = (DeviceType.IS_IPHONE_X) ? 84 : 50
let placementID = "335878217019048_338994906707379"
class BaseVC: UIViewController {
    var isShowInterestl = true
//    var nativeAd = FBNativeAd(placementID: placementID)
    var zoomOutView = ZoomOutViewPlayVideo()
//    var interstitialAd = FBInterstitialAd()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        
        TAppDelegate.menuContainerViewController?.setMenuState(MFSideMenuStateClosed, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.background()
        
        TAppDelegate.handleReturnView = {
            let vc = localDataShared.playVC
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            self.removeZoomOutView()
        }
        
        AdmobManager.shared.logEvent(isShowInterestl)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        zoomOutView.handleRemoveView = {
            self.removeZoomOutView()
        }
    }
    
    func menuContainerViewController() -> MFSideMenuContainerViewController {
        return self.navigationController?.parent as! MFSideMenuContainerViewController
    }
    
    func openMenu() {
        TAppDelegate.menuContainerViewController?.toggleLeftSideMenuCompletion(nil)
    }
    
    func insertHistory() {
        let obj = HistoryObj()
        obj.video_id = TAppDelegate.arrVideoPlaying[TAppDelegate.indexPlaying].id
        obj.creatDate = Int(Date().secondsSince1970)
        HistoryManger.shared.insertOrUpdate(obj)
    }
}

extension BaseVC {
    
    func openSetting() {
        let vc = SettingVC.init(nibName: "SettingVC", bundle: nil)
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func openProfile() {
//        let vc = ProfileVC.init(nibName: "ProfileVC", bundle: nil)
//        vc.modalPresentationStyle = .fullScreen
//        self.tabBarController?.present(vc, animated: true, completion: nil)
    }
    
    func showZoomOutView() {
        showNib()
        TAppDelegate.isShowZoomOutView = false
        zoomOutView.isPlay = !TAppDelegate.isPlay
        zoomOutView.isPlay = TAppDelegate.isPlay
        if !TAppDelegate.isShowZoomOutView {
            zoomOutView.addSubViewVideo()
            if TAppDelegate.isPlay {
                viewYoutubePlayer.playVideo()
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
    
    func goPlay(arrData: [Items], index: Int) {
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
            let vc = localDataShared.playVC
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
        attributes.displayDuration = .infinity
        attributes.screenBackground = .clear
        attributes.entryBackground = .clear
        attributes.screenInteraction = .forward
        attributes.entryInteraction = .absorbTouches
        attributes.scroll = .disabled
        
        attributes.entranceAnimation = .init(translate: .init(duration: 0.5, spring: .init(damping: 0.9, initialVelocity: 0)),
                                             scale: .init(from: 0.8, to: 1, duration: 0.5, spring: .init(damping: 0.8, initialVelocity: 0)),
                                             fade: .init(from: 0.7, to: 1, duration: 0.3))
        attributes.exitAnimation = .init(translate: .init(duration: 0.5),
                                         scale: .init(from: 1, to: 0.8, duration: 0.5),
                                         fade: .init(from: 1, to: 0, duration: 0.5))
        attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.3),
                                                            scale: .init(from: 1, to: 0.8, duration: 0.3)))
        attributes.shadow = .active(with: .init(color: .black, opacity: 0.3, radius: 6))
        attributes.positionConstraints.verticalOffset = CGFloat(DeviceType.IS_IPHONE_X ? kBarHeight - 30 : kBarHeight + 5)
        attributes.positionConstraints.size = .init(width: .offset(value: 5), height: .intrinsic)
        attributes.positionConstraints.maxSize = .init(width: .constant(value: UIScreen.main.minEdge), height: .intrinsic)
        
        attributes.statusBar = .dark
        return attributes
    }
    
    func addFavorite(_ obj: Items){
        VideoManager.shareInstance.add_remove_favorited(video: obj, true)
    }
    
    func addFavorite(_ obj: Playlist) {
        PlaylistManager.shareInstance.addfavorited(playlistId: obj.playlistId)
    }
    
    func removeFavorite(_ obj: Items) {
        VideoManager.shareInstance.add_remove_favorited(video: obj, false)
    }
    
    func removeFavorite(_ obj: Playlist) {
        PlaylistManager.shareInstance.removefavorited(playlistId: obj.playlistId)
    }
    
    func share(_ obj: Playlist) {
        Common.showAlert("Coming Soon")
    }
    
    func share(_ obj: Items) {
        Common.showAlert("Coming Soon")
    }
    
    
    func report(_ obj: Items) {
        let alert = UIAlertController(title: "txt_title_report".localized, message: "txt_msg_report".localized, preferredStyle: UIAlertController.Style.alert )
        let cancel = UIAlertAction(title: "txt_cancel".localized, style: .default) { (alertAction) in }
        alert.addAction(cancel)
        
        let done = UIAlertAction(title: "txt_send".localized, style: .default) { (alertAction) in
            let textField = alert.textFields![0] as UITextField
            let textFieldContent = alert.textFields![1] as UITextField
            if let text = textField.text, text != "" {
                DBManager().report(playlistId: obj.playlistId, videoId: obj.id, email: text, contents: textFieldContent.text ?? "", success: { (bool) in
                    if bool {
                        Common.showAlert("txt_report_success".localized)
                    }else{
                        Common.showAlert("txt_report_err".localized)
                    }
                })
            } else {
                Common.showAlert("txt_report_req".localized)
            }
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "txt_planhoder_report".localized
            textField.keyboardType = .emailAddress
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "txt_planhoder_report_ontents".localized
            textField.keyboardType = .emailAddress
        }
        alert.addAction(done)
        
        self.present(alert, animated:true, completion: nil)
    }
    
    func report(_ obj: Playlist) {
        let alert = UIAlertController(title: "txt_title_report".localized, message: "txt_msg_report".localized, preferredStyle: UIAlertController.Style.alert )
        let cancel = UIAlertAction(title: "txt_cancel".localized, style: .default) { (alertAction) in }
        alert.addAction(cancel)
        
        let done = UIAlertAction(title: "txt_send".localized, style: .default) { (alertAction) in
            let textField = alert.textFields![0] as UITextField
            let textFieldContent = alert.textFields![1] as UITextField
            if let text = textField.text, text != "" {
                DBManager().report(playlistId: obj.playlistId, videoId: "", email: text, contents: textFieldContent.text ?? "", success: { (bool) in
                    if bool {
                        Common.showAlert("txt_report_success".localized)
                    }else{
                        Common.showAlert("txt_report_err".localized)
                    }
                })
            } else {
                Common.showAlert("txt_report_req".localized)
            }
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "txt_planhoder_report".localized
            textField.keyboardType = .emailAddress
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "txt_planhoder_report_ontents".localized
            textField.keyboardType = .emailAddress
        }
        alert.addAction(done)
        
        self.present(alert, animated:true, completion: nil)
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
        tabBackground.contentMode = .scaleAspectFill
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

//extension BaseVC: FBNativeAdDelegate {
//    func nativeAdDidLoad(_ nativeAd: FBNativeAd) {
//        showNativeAd()
//    }
//
//    func showNativeAd() {
//        if self.nativeAd.isAdValid {
//            let adView = FBNativeAdView(nativeAd: self.nativeAd, with: .genericHeight300)
//            self.zoomOutView.addSubview(adView)
//            let size = self.zoomOutView.bounds.size
//            let xOffset = size.width / 2 - 160
//            let yOffset = (size.height > size.width) ? 100 : 20
//            adView.frame = CGRect(x: Int(xOffset), y: yOffset, width: 320, height: 300)
//        }
//    }
//}

//extension BaseVC: FBInterstitialAdDelegate {
//    func interstitialAdDidLoad(_ interstitialAd: FBInterstitialAd) {
//        if interstitialAd.isAdValid {
//            interstitialAd.show(fromRootViewController: self)
//        }
//    }
//    
//    func interstitialAd(_ interstitialAd: FBInterstitialAd, didFailWithError error: Error) {
//        print(error)
//    }
//}
