//
//  LibraryVC.swift
//  EasyEnglish
//
//  Created by Anh Dũng on 1/4/19.
//  Copyright © 2019 Anh Dũng. All rights reserved.
//

import UIKit

class LibraryVC: BaseVC {

    @IBOutlet weak var viewToolReight: UIView!
    @IBOutlet weak var viewToolLeft: UIView!
    @IBOutlet weak var toolBar: ToolBarView!
    @IBOutlet weak var navi: NavigationView!
    @IBOutlet weak var tableViewLeft: UITableView!
    @IBOutlet weak var tableViewRight: UITableView!
    
    var viewModelNote = ListNoteModelView()
    var viewModelHistory = ListNoteModelView()
    
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
        initData()
    }
    
}

extension LibraryVC {
    func initUI() {
        TAppDelegate.handleReloadDataNotes = {
            self.loadData()
        }
        navi.title = ""
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
        }
    }
    
    func loadData(){
        if toolBar.indexSelected == 0 {
            loadDataNote()
        }else{
            
        }
    }
    
    func loadDataNote() {
        self.arrNote = VideoManager.shareInstance.fetchAllForNote()
        viewModelNote.arrData = self.arrNote
        tableViewLeft.reloadData()
    }
    
    func loadDataHistory() {
        self.arrHistory = VideoManager.shareInstance.fetchAllForNote()
        viewModelNote.arrData = self.arrNote
        tableViewLeft.reloadData()
    }
    
    func initData() {
        loadData()
    }
}
