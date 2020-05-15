//
//  DetailTuDienVC.swift
//  EasyJapanese
//
//  Created by Phung Anh Dung on 4/27/20.
//  Copyright © 2020 Anh Dũng. All rights reserved.
//

import UIKit

class DetailTuDienVC: BaseVC {

    @IBOutlet weak var viewVidu: UIView!
    @IBOutlet weak var viewKanji: UIView!
    @IBOutlet weak var lblKana: KHLabel!
    @IBOutlet weak var ctrHeightVidu: NSLayoutConstraint!
    @IBOutlet weak var ctrHeightKanji: NSLayoutConstraint!
    @IBOutlet weak var tableVidu: UITableView!
    @IBOutlet weak var tableKanji: UITableView!
    @IBOutlet weak var lblNghia: KHLabel!
    @IBOutlet weak var btnGhiChu: UIButton!
    @IBOutlet weak var lblOrgin: KHLabel!
    @IBOutlet weak var navi: NavigationView!
    @IBOutlet weak var ctrHeighNote: NSLayoutConstraint!
    @IBOutlet weak var tvNote: UITextView!
    
    var tudienObj = TuDienBaseObj()
    var typeList: TypeListTuDien = .NhatViet
    var arrKanji = [KanjiBaseObj]()
    var arrVidu = [ExampleObj]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navi.handleBack = {
            self.clickBack()
        }
        initUI()
        initData()
    }
    
    @IBAction func btnXemThemGoiY(_ sender: Any) {
        let browserView = BrowserViews()
        var keyword = ""
        keyword = tudienObj.origin?.encode() ?? ""
        browserView.urls = "https://www.tudienabc.com/tra-nghia/nhat-anh-viet-han/\(keyword)"
        self.present(browserView, animated: true, completion: nil)
    }
    
    func initUI() {
        lblOrgin.text = tudienObj.origin
        lblNghia.text = tudienObj.definition
        lblKana.text = tudienObj.kana
        tvNote.text = tudienObj.note
        tableKanji.delegate = self
        tableKanji.dataSource = self
        tableKanji.register(CellKanjiInDetail.self)
        
        tableVidu.delegate = self
        tableVidu.dataSource = self
        tableVidu.register(CellViduInDetail.self)
        
        navi.title = tudienObj.origin ?? ""
        tvNote.delegate = self
    }
    
    func initData() {
        arrKanji = KanjiManager.shared.fetchAllDataWithBaseText(baseText: tudienObj.origin ?? "")
        if typeList == .NhatViet {
            arrVidu = NhatVietManager.shared.fetchExampleWithID(tudienObj.docid ?? 0)
        }
        
        if typeList == .NguPhap {
            arrVidu = NguPhapManager.shared.fetchExampleWithID(tudienObj.docid ?? 0)
        }
        
        tableKanji.reloadData()
        tableVidu.reloadData()
        viewKanji.isHidden = arrKanji.count == 0
        viewVidu.isHidden = arrVidu.count == 0
    }
    
}

extension DetailTuDienVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableKanji {
            return arrKanji.count
        }else{
            return arrVidu.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableKanji {
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as CellKanjiInDetail
            UIView.animate(withDuration: 0, animations: {
                self.tableKanji.layoutIfNeeded()
            }) { complete in
                self.ctrHeightKanji.constant = self.tableKanji.contentSize.height
            }
            cell.config(obj: arrKanji[indexPath.row])
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as CellViduInDetail
            UIView.animate(withDuration: 0, animations: {
                self.tableVidu.layoutIfNeeded()
            }) { complete in
                self.ctrHeightVidu.constant = self.tableVidu.contentSize.height
            }
            cell.setUpLabel(obj: arrVidu[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tableKanji {
            let vc = DetailKanjiVC()
            vc.kanjiModel = arrKanji[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension DetailTuDienVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        tudienObj.note = textView.text
        switch typeList {
        case .NhatViet:
            NhatVietManager.shared.updateNote(tudienObj)
            break
        case .VietNhat:
            VietNhatManager.shared.updateNote(tudienObj)
            break
        case .NguPhap:
            NguPhapManager.shared.updateNote(tudienObj)
            break
        default:
            break
        }
    }
}
