//
//  PlayVC.swift
//  EasyEnglish
//
//  Created by Anh Dũng on 12/30/18.
//  Copyright © 2018 Anh Dũng. All rights reserved.
//

import UIKit
import YouTubePlayer
//import FBAudienceNetwork

class PlayVC: BaseVC {

    @IBOutlet weak var btMoreBack: KHButton!
    @IBOutlet weak var viewToolPlay2: UIView!
    @IBOutlet weak var imageSub: UIImageView!
    @IBOutlet weak var lbDislike: UILabel!
    @IBOutlet weak var lbLiker: UILabel!
    @IBOutlet weak var lbViewer: UILabel!
    @IBOutlet weak var lbTitleVideo: UILabel!
    @IBOutlet weak var lbTimeEnd: UILabel!
    @IBOutlet weak var lbTimeStart: UILabel!
    @IBOutlet weak var lbTitileSub: UILabel!
    @IBOutlet weak var lbSub: UILabel!
    //
    @IBOutlet weak var silder: UISlider!
    @IBOutlet weak var btPlayPause: UIButton!
    @IBOutlet weak var viewToolBarPlayer: UIView!
    @IBOutlet weak var ctrHeightViewVideo: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewPlayer: UIView!
    @IBOutlet weak var btInfoVideo: UIButton!
    @IBOutlet weak var btAutoPlay: UIButton!
    @IBOutlet weak var ctrHeighViewMoreInfo: NSLayoutConstraint!
    @IBOutlet weak var viewMoreInfoVideo: UIView!
    @IBOutlet weak var ctrHeightViewNote: NSLayoutConstraint!
    @IBOutlet weak var lbStatusNote: UILabel!
    @IBOutlet weak var textViewNote: UITextView!
    @IBOutlet weak var viewNote: UIView!
    @IBOutlet weak var adView: KHView!
    
    var viewModel = ListModelView()
    var current: Int = 0
    var duration: Int = 0
//    var adViews = FBAdView()
    var isAutoPlay = false {
        didSet{
            btAutoPlay.setImage(isAutoPlay ? UIImage(named: "ic_auto_play_on") : UIImage(named: "ic_auto_play_off"), for: .normal)
        }
    }
    
    var isPlay = false {
        didSet{
           btPlayPause.setImage(isPlay ? UIImage(named: "ic_play_play") : UIImage(named: "ic_play_pause"), for: .normal)
        }
    }
    
    var isMoreInfoVideo = false {
        didSet{
            if isMoreInfoVideo {
                ctrHeighViewMoreInfo.constant = 51*heightRatio
                viewMoreInfoVideo.isHidden = false
            }else{
                ctrHeighViewMoreInfo.constant = 0
                viewMoreInfoVideo.isHidden = true
            }
            btInfoVideo.setImage(isMoreInfoVideo ? UIImage(named: "ic_un_collaps") : UIImage(named: "ic_collapte"), for: .normal)
        }
    }
    
    var isShowNote = false {
        didSet{
            if isShowNote {
                ctrHeightViewNote.constant = 200*heightRatio
                viewNote.isHidden = false
            }else{
                ctrHeightViewNote.constant = 0
                viewNote.isHidden = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        initData()
        setDetailVideo(video: TAppDelegate.arrVideoPlaying[TAppDelegate.indexPlaying])
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape {
            print("Landscape")
            ctrHeightViewVideo.constant = ScreenSize.SCREEN_HEIGHT + (DeviceType.IS_IPHONE_X ? 21 : 0)
        } else {
            print("Portrait")
            ctrHeightViewVideo.constant = ScreenSize.SCREEN_WIDTH * 9 / 16
        }
    }
    

    @IBAction func actionCollapsMoreInfo(_ sender: Any) {
        isMoreInfoVideo = !isMoreInfoVideo
    }
    
    @IBAction func actionShowEditNote(_ sender: Any) {
        isShowNote = !isShowNote
    }
    
    @IBAction func actionAutoPlay(_ sender: Any) {
        isAutoPlay = !isAutoPlay
        TAppDelegate.isAutoPlay = isAutoPlay
    }
    
    @IBAction func actionToolBar(_ sender: UIButton) {
        //601
        switch sender.tag {
        case 601: // hien toolbar
            if !UserDefaults.standard.bool(forKey: "TOOLBARPLAY") {
                viewToolBarPlayer.isHidden = false
            }
            break
        case 602: //add playlist
            print(sender.tag)
            actionSheet()
            break
        case 603: //share
            print(sender.tag)
            actionSheetShare()
            break
        case 604: //more
            print(sender.tag)
            break
        case 605: // mo rong thu nho
            print(sender.tag)
            break
        case 606: //back
            print(sender.tag)
            TAppDelegate.indexPlaying -= 1
            if TAppDelegate.indexPlaying < 0{
                TAppDelegate.indexPlaying = 0
            }
            viewYoutubePlayer.loadVideoID(TAppDelegate.arrVideoPlaying[TAppDelegate.indexPlaying].id)
            self.tableView.selectRow(at: IndexPath(row: TAppDelegate.indexPlaying, section: 0), animated: true, scrollPosition: .top)
            break
        case 607: // pause sit top
            print(sender.tag)
            isPlay = !isPlay
            TAppDelegate.isPlay = !TAppDelegate.isPlay
            if isPlay {
                viewYoutubePlayer.pause()
            }else{
                viewYoutubePlayer.play()
            }
            break
        case 608: // next
            print(sender.tag)
            TAppDelegate.indexPlaying += 1
            if TAppDelegate.indexPlaying == TAppDelegate.arrVideoPlaying.count{
                TAppDelegate.indexPlaying = 0
            }
            viewYoutubePlayer.loadVideoID(TAppDelegate.arrVideoPlaying[TAppDelegate.indexPlaying].id)
            self.tableView.selectRow(at: IndexPath(row: TAppDelegate.indexPlaying, section: 0), animated: true, scrollPosition: .top)
            break
        case 609: //mo rong man hinh
            print(sender.tag)
            if TAppDelegate.deviceOrientation == .portrait {
                TAppDelegate.deviceOrientation = .landscapeRight
                let value = UIInterfaceOrientation.landscapeRight.rawValue
                UIDevice.current.setValue(value, forKey: "orientation")
                self.frameViewPlay(self.viewPlayer)
            }else{
                TAppDelegate.deviceOrientation = .portrait
                let value = UIInterfaceOrientation.portrait.rawValue
                UIDevice.current.setValue(value, forKey: "orientation")
                self.frameViewPlay(self.viewPlayer)
            }
            break
        case 613: //add playlist
            print(sender.tag)
            actionSheet()
            break
        case 612: //share
            print(sender.tag)
            actionSheetShare()
            break
        default:
            print(sender.tag)
        }
    }
    
    @IBAction func actionToolBarDragExit(_ sender: UIButton) {
        self.back()
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.back()
    }
    
    @IBAction func actionToolBarDragRepeat(_ sender: UIButton) {
        switch sender.tag {
        case 610: //tua luu
            print(sender.tag)
            self.current = self.current - 10
            viewYoutubePlayer.seekTo(Float(self.current), seekAhead: true)
            break
        case 611: // tua toi
            print(sender.tag)
            self.current = self.current + 10
            viewYoutubePlayer.seekTo(Float(self.current), seekAhead: true)
            break
        default:
            break
        }
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        viewYoutubePlayer.seekTo(Float(currentValue), seekAhead: true)
    }
}

extension PlayVC {
    func initUI() {
//        adViews = FBAdView(placementID: "335878217019048_338994906707379", adSize: kFBAdSizeHeight50Banner, rootViewController: self)
//        adView.addSubview(adViews)
//        adViews.frame = adView.frame
//
//        adViews.delegate = self
//        adViews.loadAd()
        
        imageSub.image = randomAvatar()
        textViewNote.delegate = self
        ctrHeightViewVideo.constant = ScreenSize.SCREEN_WIDTH * 9 / 16
        tableView.register(VideoPlayCell.self)
        tableView.delegate = viewModel
        tableView.dataSource = viewModel
        viewModel.isPlaylist = true
        viewYoutubePlayer.translatesAutoresizingMaskIntoConstraints = false
        viewPlayer.addSubview(viewYoutubePlayer)
        frameViewPlay(viewPlayer)
        isAutoPlay = TAppDelegate.isAutoPlay
        isShowNote = TAppDelegate.arrVideoPlaying[TAppDelegate.indexPlaying].notes != ""
        
        if TAppDelegate.isPlay {
            viewYoutubePlayer.play()
        }
        
        if TAppDelegate.isNew {
            viewYoutubePlayer.loadVideoID(TAppDelegate.idVideoPlaying)
        }
        
        Timer.every(7) {
            if !self.viewToolBarPlayer.isHidden {
                if TAppDelegate.isPlay {
                    self.viewToolBarPlayer.isHidden = true
                }else{
                    self.viewToolBarPlayer.isHidden = false
                }
                
            }
        }
        
        youtubeShare.handleDuration = { (str) in
            self.duration = Int(str) ?? 0
            self.lbTimeEnd.text = self.timeStringFrom(self.duration)
            self.silder.maximumValue = Float(str) ?? 0
        }
        
        youtubeShare.handleCurentime = { (current,duration) in
            self.current = Int(Float(current) ?? 0)
            self.duration = Int(Float(duration) ?? 0) - Int(Float(current) ?? 0)
            self.lbTimeEnd.text = self.timeStringFrom(self.duration)
            self.lbTimeStart.text = self.timeStringFrom(self.current ,self.duration)
            self.silder.value = Float(current) ?? 0
        }
        
        youtubeShare.handleAutoPlay = {
            self.tableView.selectRow(at: IndexPath(row: TAppDelegate.indexPlaying, section: 0), animated: true, scrollPosition: .top)
        }
        
        TAppDelegate.handleReturnForeground = {
            self.isPlay = !TAppDelegate.isPlay
        }
        
        viewModel.handleSelectRow = { (index) in
            if index != TAppDelegate.indexPlaying {
                viewYoutubePlayer.loadVideoID(TAppDelegate.arrVideoPlaying[index].id)
                TAppDelegate.indexPlaying = index
                self.setDetailVideo(video: TAppDelegate.arrVideoPlaying[index])
            }
        }
        viewModel.handleMoreOptionCell = { (item) in
            let title = VideoManager.shareInstance.checkFavorited(videoId: item.id) ? "txt_remove_fa_video".localized : "txt_add_fa_video".localized
            _ = UIAlertController.present(style: .actionSheet, title: "txt_select_action".localized, message: nil, attributedActionTitles: [(title, .default), ("txt_share".localized, .default), ("txt_cancel".localized, .cancel)], handler: { (action) in
                if action.title == "txt_remove_fa_video".localized {
                    self.removeFavorite(item)
                }
                if action.title == "txt_add_fa_video".localized {
                    self.addFavorite(item)
                }
                if action.title == "txt_share".localized {
                    self.share(item)
                }
            })
        }
        configToolbarTF()
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapFunction(sender:)))
        lbTitileSub.isUserInteractionEnabled = true
        lbTitileSub.addGestureRecognizer(tap)
        
        if UserDefaults.standard.bool(forKey: "TOOLBARPLAY") {
            viewToolBarPlayer.isHidden = true
            viewToolPlay2.isHidden = true
            btMoreBack.isHidden = false
        }
    }
    
    @objc
    func tapFunction(sender:UITapGestureRecognizer) {
        print("tap working")
        let vc = ListVideoVC(nibName: "ListVideoVC",bundle: nil)
        vc.arrData = TAppDelegate.arrVideoPlaying
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func initData() {
        for index in TAppDelegate.arrVideoPlaying.indices {
            let item = VideoManager.shareInstance.getInfoVideoDB(video: TAppDelegate.arrVideoPlaying[index])
            
            TAppDelegate.arrVideoPlaying[index].notes = item.notes
            TAppDelegate.arrVideoPlaying[index].timeUpdate = item.timeUpdate
        }
        viewModel.arrData = TAppDelegate.arrVideoPlaying
//        tableView.reloadData()
        self.tableView.selectRow(at: IndexPath(row: TAppDelegate.indexPlaying, section: 0), animated: true, scrollPosition: .top)
    }
    
    func setDetailVideo(video: Items) {
        lbTitleVideo.text = video.snippet.title
        lbViewer.text = "\(Int(video.statistics.viewCount) ?? 0 * 3) lượt xem"
        textViewNote.text = video.notes
        lbStatusNote.text = "\(Date.init(seconds: video.timeUpdate).string("dd/MM/yyyy hh:mm a")) | Auto save"
        lbTitileSub.text = TAppDelegate.titlePlaylist
        lbSub.text = TAppDelegate.titleCatagory
        lbDislike.text = "\(Int(video.statistics.dislikeCount) ?? 0 * 4) K"
        lbLiker.text = "\(Int(video.statistics.likeCount) ?? 0 * 4) K"
    }
    
    func frameViewPlay(_ view : UIView) {
        viewYoutubePlayer.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        viewYoutubePlayer.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        viewYoutubePlayer.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        viewYoutubePlayer.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    }
    
    func timeStringFrom(_ second: Int,_ duration: Int = 1) -> String {
        if second == 0 {
            return "00:00"
        }else{
            if duration >= 3600 || second >= 3600 {
                let (h,m,s) = Int().secondsToHoursMinutesSeconds(seconds: second)
                return "\(h):\(m):\(s)"
            }else{
                let (m,s) = Int().secondsToMinutesSeconds(seconds: second)
                return "\(m):\(s)"
            }
        }
    }
    
    func back(){
        self.clickBack()
        TAppDelegate.isNew = false
        showZoomOutView()
    }
}

extension PlayVC {
    func configToolbarTF() {
        let numberToolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        numberToolbar.barStyle = .default
        numberToolbar.barTintColor = UIColor("FF7934", alpha: 1.0)
        numberToolbar.backgroundColor =  UIColor.clear //UIColor("FF7934", alpha: 1.0)
        numberToolbar.setBackgroundImage(UIImage(named: "bg"), forToolbarPosition: .top, barMetrics: .default)
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(doneWithNumberPad))
        cancel.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white], for: .normal)
        let done = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneWithNumberPad))
        done.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white], for: .normal)
        numberToolbar.items = [
            cancel,
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),done
        ]
        numberToolbar.sizeToFit()
        textViewNote.inputAccessoryView = numberToolbar
    }
    
    @objc func cancelNumberPad() {
        textViewNote.endEditing(true)
    }
    
    @objc func doneWithNumberPad() {
        textViewNote.endEditing(true)
    }
    
    func actionSheet() {
        let itemVideo = TAppDelegate.arrVideoPlaying[TAppDelegate.indexPlaying]
        let titleVideo = VideoManager.shareInstance.checkFavorited(videoId: itemVideo.id) ? "txt_remove_fa_video".localized : "txt_add_fa_video".localized
        let itemPlaylist = PlaylistManager.shareInstance.getInfoPlaylistDB(playlistId: TAppDelegate.arrVideoPlaying[TAppDelegate.indexPlaying].playlistId)
        let titlePlaylist = PlaylistManager.shareInstance.checkFavorite(playlist: itemPlaylist) ? "txt_remove_fa_playlist".localized : "txt_add_fa_playlist".localized
        
        _ = UIAlertController.present(style: .actionSheet, title: "txt_select_action".localized, message: nil, attributedActionTitles: [(titleVideo, .default), (titlePlaylist, .default), ("txt_cancel".localized, .cancel)], handler: { (action) in
            if action.title == "txt_add_fa_video".localized {
                self.addFavorite(itemVideo)
            }
            if action.title == "txt_remove_fa_video".localized {
                self.removeFavorite(itemVideo)
            }
            if action.title == "txt_add_fa_playlist".localized {
                self.addFavorite(itemPlaylist)
            }
            if action.title == "txt_remove_fa_playlist".localized {
                self.removeFavorite(itemPlaylist)
            }
        })
    }
    
    func actionSheetShare() {
        let itemVideo = TAppDelegate.arrVideoPlaying[TAppDelegate.indexPlaying]
        let itemPlaylist = PlaylistManager.shareInstance.getInfoPlaylistDB(playlistId: TAppDelegate.arrVideoPlaying[TAppDelegate.indexPlaying].playlistId)
        _ = UIAlertController.present(style: .actionSheet, title: "txt_select_action".localized, message: nil, attributedActionTitles: [("txt_share_video".localized, .default), ("txt_share_playlist".localized, .default), ("txt_cancel".localized, .cancel)], handler: { (action) in
            if action.title == "txt_share_video".localized {
                self.share(itemVideo)
            }
            if action.title == "txt_share_playlist".localized {
                self.share(itemPlaylist)
            }
        })
    }
    
    func randomAvatar() -> UIImage {
        let number = Int.random(in: 1 ..< 10)
        return UIImage(named: "\(number)")!
    }
    
    func popBack() {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension PlayVC : UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        TAppDelegate.arrVideoPlaying[TAppDelegate.indexPlaying].notes = textView.text ?? ""
        TAppDelegate.arrVideoPlaying[TAppDelegate.indexPlaying].timeUpdate = Date().secondsSince1970
        VideoManager.shareInstance.updateNotesVideo(video: TAppDelegate.arrVideoPlaying[TAppDelegate.indexPlaying])
        self.setDetailVideo(video: TAppDelegate.arrVideoPlaying[TAppDelegate.indexPlaying])
        TAppDelegate.handleReloadDataNotes?()
    }
}

//extension PlayVC : FBAdViewDelegate {
//    func adView(_ adView: FBAdView, didFailWithError error: Error) {
//        print("Ad failed to load")
//        print(error)
//    }
//
//    func adViewDidLoad(_ adView: FBAdView) {
//        showBanner()
//    }
//    func showBanner() {
//        if (self.adViews.isAdValid) {
//            self.adView.addSubview(self.adViews)
//        }
//    }
//}


