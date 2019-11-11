//
//  ListVideoVC.swift
//  EasyEnglish
//
//  Created by Anh Dũng on 1/5/19.
//  Copyright © 2019 Anh Dũng. All rights reserved.
//

import UIKit

class ListVideoVC: BaseVC {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navi: NavigationView!
    @IBOutlet weak var adView: UIView!
    @IBOutlet weak var ctrHeightViewAd: NSLayoutConstraint!
    
    var viewModel = ListModelView()
    var arrData = [Items]()
    var playlist = Playlist()
    var categories = Category()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ctrHeightViewAd.constant = adSize.size.height
        AdmobManager.shared.addBannerInView(view: adView, inVC: self)
    }

}

extension ListVideoVC {
    func initUI() {
        navi.title = playlist.title ?? ""
        navi.handleBack = {
            self.clickBack()
        }
        tableView.register(VideoPlayCell.self)
        tableView.delegate = viewModel
        tableView.dataSource = viewModel
        viewModel.isPlaylist = true
        
        viewModel.handleSelectRow = { (index) in
            TAppDelegate.idVideoPlaying = self.arrData[index].id
            TAppDelegate.arrVideoPlaying = self.arrData
            TAppDelegate.titlePlaylist = self.playlist.title ?? ""
            TAppDelegate.titleZoomView = self.arrData[index].snippet.title
            if !TAppDelegate.isShowZoomOutView {
                if TAppDelegate.indexPlaying != index {
                    viewYoutubePlayer.loadVideoID(TAppDelegate.idVideoPlaying)
                }
            }else{
                let vc = localDataShared.playVC
                TAppDelegate.isNew = true
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            TAppDelegate.indexPlaying = index
            self.tableView.deselectRow(at: IndexPath(row: index, section: 0), animated: true)
        }
        
        viewModel.handleMoreOptionCell = { (item) in
            let title = VideoManager.shareInstance.checkFavorited(videoId: item.id) ? "txt_remove_fa_video".localized : "txt_add_fa_video".localized
            _ = UIAlertController.present(style: .actionSheet, title: "txt_select_action".localized, message: nil, attributedActionTitles: [(title, .default), ("txt_share".localized, .default), ("txt_report".localized, .default), ("txt_cancel".localized, .cancel)], handler: { (action) in
                if action.title == "txt_remove_fa_video".localized {
                    self.removeFavorite(item)
                }
                if action.title == "txt_add_fa_video".localized {
                    self.addFavorite(item)
                }
                if action.title == "txt_share".localized {
                    self.share(item)
                }
                if action.title == "txt_report".localized {
                    self.report(item)
                }
            })
        }
    }
    
    func initData() {
        viewModel.arrData = arrData
        tableView.reloadData()
    }
    
    func loadData() {
        VideoManager.shareInstance.fethVideoListAPI(playlistId: playlist.playlistId, isShowLoad: false, success: { (respone) in
            var videoIds = ""
            let itemsVideo = respone["items"].arrayValue
            if itemsVideo.count > 0 {
                //Update lai database
                let item = itemsVideo[0]
                self.playlist.title = item["snippet"]["title"].stringValue
                self.playlist.thumbnail = item["snippet"]["thumbnails"]["medium"]["url"].stringValue
                self.playlist.totalVideo = respone["pageInfo"]["totalResults"].intValue
                PlaylistManager.shareInstance.insert_update_playlist(obj: self.playlist)
            }
            for i in itemsVideo {
                let videoId = i["snippet"]["resourceId"]["videoId"].stringValue
                videoIds.append(videoId+",")
            }
            if videoIds.count > 0 {
                videoIds.removeLast()
            }
            VideoManager.shareInstance.getInfoVideo(videoId: videoIds, success: { (videos) in
                self.arrData = videos.items
                self.initData()
                for i in videos.items {
                    i.playlistId = self.playlist.playlistId
                    i.subTitle = "\(self.categories.name) / \(self.playlist.title ?? "")"
                    VideoManager.shareInstance.addVideo(videoItem: i)
                }
            })
        })
    }
}
