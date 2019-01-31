//
//  LibraryVC.swift
//  EasyEnglish
//
//  Created by Anh Dũng on 1/4/19.
//  Copyright © 2019 Anh Dũng. All rights reserved.
//

import UIKit

class LibraryVC: BaseVC {

    @IBOutlet weak var btShow: KHButton!
    @IBOutlet weak var lbStatus: KHLabel!
    @IBOutlet weak var viewToolReight: UIView!
    @IBOutlet weak var viewToolLeft: UIView!
    @IBOutlet weak var toolBar: ToolBarView!
    @IBOutlet weak var navi: NavigationView!
    @IBOutlet weak var tableViewLeft: UITableView!
    @IBOutlet weak var tableViewRight: UITableView!
    
    var viewModelNote = ListNoteModelView()
    var viewModelHistory = ListModelView()
    
    var arrNote = [Items]()
    var arrHistory = [Items]()
    
    var swicthView = false {
        didSet {
            if swicthView {
                viewToolLeft.isHidden = true
                viewToolReight.isHidden = false
            }else{
                viewToolLeft.isHidden = false
                viewToolReight.isHidden = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.loadDataAllHistory()
    }
    
    @IBAction func actionShowAllHistory(_ sender: Any) {
        loadData()
    }
    
}

extension LibraryVC {
    func initUI() {
        navi.title = "txt_library".localized.uppercased()
        
        navi.handleSetting = {
            self.openSetting()
        }
        navi.handleProfile = {
            self.openProfile()
        }
        
        TAppDelegate.handleReloadDataNotes = {
            self.loadData()
        }
        
        toolBar.handleActionG2Left = {
            self.swicthView = false
        }
        
        toolBar.handleActionG2Right = {
            self.swicthView = true
        }
        
        tableViewLeft.register(NotesCell.self)
        tableViewLeft.delegate = viewModelNote
        tableViewLeft.dataSource = viewModelNote
        viewModelNote.handleSelectRow = { (index) in
            self.goPlay(arrData: self.arrNote, index: index)
            self.tableViewLeft.deselectRow(at: IndexPath(row: index, section: 0), animated: true)
        }
        
        tableViewRight.register(VideoPlayCell.self)
        tableViewRight.delegate = viewModelHistory
        tableViewRight.dataSource = viewModelHistory
        viewModelHistory.isPlaylist = true
        viewModelHistory.isHisotryView = true
        viewModelHistory.handleSelectRow = { (index) in
            self.goPlay(arrData: self.arrHistory, index: index)
            self.tableViewRight.deselectRow(at: IndexPath(row: index, section: 0), animated: true)
        }
        viewModelHistory.handleMoreOptionCell = { (item) in
            _ = UIAlertController.present(style: .actionSheet, title: "txt_select_action".localized, message: nil, attributedActionTitles: [("txt_delete_history_video".localized, .default), ("txt_delete_all_hitory_video".localized, .default), ("txt_cancel".localized, .cancel)], handler: { (action) in
                if action.title == "txt_delete_history_video".localized {
                    HistoryManger.shared.removeHistory(item)
                    self.loadData()
                }
                if action.title == "txt_delete_all_hitory_video".localized {
                    HistoryManger.shared.removeAllHistory()
                    self.loadData()
                }
            })
        }
    }
    
    func loadData(){
        if toolBar.indexSelected == 0 {
            loadDataNote()
            tableViewLeft.backgroundColor = self.arrNote.count == 0 ? UIColor.clear : UIColor.white
        }else{
            if lbStatus.text == "txt_last_10_video".localized {
                btShow.setTitle("txt_show_10".localized, for: .normal)
                lbStatus.text = "txt_all_history".localized
                loadDataAllHistory()
            }else{
                btShow.setTitle("txt_show_all_history".localized, for: .normal)
                lbStatus.text = "txt_last_10_video".localized
                loadDataTop10History()
            }
            tableViewRight.backgroundColor = self.arrHistory.count == 0 ? UIColor.clear : UIColor.white
        }
    }
    
    func loadDataNote() {
        self.arrNote = VideoManager.shareInstance.fetchAllForNote()
        viewModelNote.arrData = self.arrNote
        tableViewLeft.reloadData()
    }
    
    func loadDataTop10History() {
        self.arrHistory = HistoryManger.shared.fetchTop10History()
        viewModelHistory.arrData = self.arrHistory
        tableViewRight.reloadData()
    }
    
    func loadDataAllHistory() {
        self.arrHistory = HistoryManger.shared.fetchAllHistory()
        viewModelHistory.arrData = self.arrHistory
        tableViewRight.reloadData()
    }
}

