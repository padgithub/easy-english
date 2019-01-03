//
//  PlayVC.swift
//  EasyEnglish
//
//  Created by Anh Dũng on 12/30/18.
//  Copyright © 2018 Anh Dũng. All rights reserved.
//

import UIKit

class PlayVC: BaseVC {

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
    
    var viewModel = ListModelView()
    var viewPlayss = VideoServiceView.shared.viewPlayer
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape {
            print("Landscape")
            ctrHeightViewVideo.constant = ScreenSize.SCREEN_HEIGHT
        } else {
            print("Portrait")
            ctrHeightViewVideo.constant = ScreenSize.SCREEN_HEIGHT*255/812
        }
    }
    

    @IBAction func actionCollapsMoreInfo(_ sender: Any) {
        isMoreInfoVideo = !isMoreInfoVideo
        self.navigationController?.popViewController(animated: true)
        showZoomOutView()
        
    }
    
    @IBAction func actionAutoPlay(_ sender: Any) {
        isAutoPlay = !isAutoPlay
        TAppDelegate.isPlay = true
        VideoServiceView.shared.loadVideo()
    }
    
    @IBAction func actionToolBar(_ sender: UIButton) {
        //601
        switch sender.tag {
        case 601: // hien toolbar
            viewToolBarPlayer.isHidden = false
            print(sender.tag)
            break
        case 602: //add playlist
            print(sender.tag)
            break
        case 603: //share
            print(sender.tag)
            break
        case 604: //more
            print(sender.tag)
            break
        case 605: // mo rong thu nho
            print(sender.tag)
            break
        case 606: //back
            print(sender.tag)
            break
        case 607: // pause sit top
            print(sender.tag)
            break
        case 608: // next
            print(sender.tag)
            break
        case 609: //mo rong man hinh
            print(sender.tag)
            break
        case 610: //tua luu
            print(sender.tag)
            break
        case 611: // tua toi
            print(sender.tag)
            break
        default:
            print(sender.tag)
        }
    }
    
}

extension PlayVC {
    func initUI() {
        tableView.register(VideoPlayCell.self)
        tableView.delegate = viewModel
        tableView.dataSource = viewModel
        viewModel.isPlaylist = true
        
        viewPlayss.removeFromSuperview()
        viewPlayss.translatesAutoresizingMaskIntoConstraints = false
        viewPlayer.addSubview(viewPlayss)
        frameViewPlay(viewPlayer)
        if TAppDelegate.isPlay {
            VideoServiceView.shared.viewPlayer.play()
        }
        Timer.every(7) {
            if !self.viewToolBarPlayer.isHidden {
                self.viewToolBarPlayer.isHidden = true
            }
        }
    }
    
    func frameViewPlay(_ view : UIView) {
        viewPlayss.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        viewPlayss.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        viewPlayss.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        viewPlayss.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    }
}

