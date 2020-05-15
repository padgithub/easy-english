//
//  DetailKanjiVC.swift
//  EasyJapanese
//
//  Created by Phung Anh Dung on 5/11/20.
//  Copyright © 2020 Anh Dũng. All rights reserved.
//

import UIKit

class DetailKanjiVC: BaseVC {
    @IBOutlet weak var lblSoNet: KHLabel!
    
    @IBOutlet weak var ctrHieghTuLienQuan: NSLayoutConstraint!
    @IBOutlet weak var tableViewTLQ: UITableView!
    @IBOutlet weak var ctrHeightBTP: NSLayoutConstraint!
    @IBOutlet weak var navi: NavigationView!
    @IBOutlet weak var lblDoThongDung: KHLabel!
    @IBOutlet weak var lblCapDo: KHLabel!
    @IBOutlet weak var lblOnyomi: KHLabel!
    @IBOutlet weak var lblKunyomi: KHLabel!
    @IBOutlet weak var lblNghia: KHLabel!
    @IBOutlet weak var lblHanTu: KHLabel!
    @IBOutlet weak var lblTu: KHLabel!
    
    @IBOutlet weak var tvNote: KHTextView!
    @IBOutlet weak var tableViewBTP: UITableView!
    
    var kanjiModel = KanjiBaseObj()
    
    var arrBoThanPhan = [BoThanhPhanObj]()
    var arrTuLienQuan = [TuDienBaseObj]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTu.text = kanjiModel.kanji
        lblHanTu.text = kanjiModel.hanviet
        lblNghia.text = kanjiModel.meaning
        lblKunyomi.text = kanjiModel.kunyomi
        lblOnyomi.text = kanjiModel.onyomi
        lblSoNet.text = kanjiModel.stroke
        lblCapDo.text = "\(kanjiModel.level ?? 0)"
        lblDoThongDung.text = "\(kanjiModel.freq ?? 0)"
        tvNote.text = kanjiModel.note
        navi.title = kanjiModel.kanji ?? ""
        navi.handleBack = {
            self.clickBack()
        }
        
        tableViewBTP.register(CellKanjiInDetail.self)
        arrBoThanPhan = KanjiManager.shared.fetchAllDataBoThanhPhan(kanjiModel._id ?? 0)
        
        tableViewTLQ.register(CellTuLienQuan.self)
        arrTuLienQuan = NhatVietManager.shared.fetchTuLienQuan(kanjiModel.kanji ?? "")
        
        tvNote.delegate = self
    }
    
}

extension DetailKanjiVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableViewBTP {
            return arrBoThanPhan.count
        }else{
            return arrTuLienQuan.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableViewBTP {
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as CellKanjiInDetail
            UIView.animate(withDuration: 0, animations: {
                self.tableViewBTP.layoutIfNeeded()
            }) { complete in
                self.ctrHeightBTP.constant = self.tableViewBTP.contentSize.height
            }
            cell.config(obj: arrBoThanPhan[indexPath.row])
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as CellTuLienQuan
            UIView.animate(withDuration: 0, animations: {
                self.tableViewTLQ.layoutIfNeeded()
            }) { complete in
                self.ctrHieghTuLienQuan.constant = self.tableViewTLQ.contentSize.height
            }
            cell.configNhatViet(obj: arrTuLienQuan[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tableViewTLQ {
            let vc = DetailTuDienVC()
            vc.typeList = .NhatViet
            vc.tudienObj = arrTuLienQuan[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension DetailKanjiVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        kanjiModel.note = textView.text
        KanjiManager.shared.updateNote(kanjiModel)
    }
}
