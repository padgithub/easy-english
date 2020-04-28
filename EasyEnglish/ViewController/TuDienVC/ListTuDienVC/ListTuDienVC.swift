//
//  ListTuDienVC.swift
//  EasyEnglish
//
//  Created by Phung Anh Dung on 4/27/20.
//  Copyright © 2020 Anh Dũng. All rights reserved.
//

import UIKit

enum TypeListTuDien: Int {
    case NhatViet = 0
    case VietNhat
    case Kanji
    case NguPhap
    case NhatAnh
}

class ListTuDienVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var type: TypeListTuDien = .NhatViet
    
    var arrKanji = [KanjiBaseObj]()
    var arrTuDien = [TuDienBaseObj]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CellListTuDien.self)
        tableView.register(CellListKanji.self)
        initData()
    }
    
    deinit {
    }
    
    func initData() {
        switch type {
        case .Kanji:
            arrKanji = KanjiManager.shared.fetchAllDataWithLevel(1)
        case .NhatViet:
            arrTuDien = NhatVietManager.shared.fetchAllData()
        case .VietNhat:
            arrTuDien = VietNhatManager.shared.fetchAllData()
        case .NguPhap:
            arrTuDien = NguPhapManager.shared.fetchAllData()
        default:
            break
        }
        tableView.reloadData()
    }
}

extension ListTuDienVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch type {
        case .Kanji:
            return arrKanji.count
        default:
            return arrTuDien.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch type {
        case .Kanji:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as CellListKanji
            cell.config(obj: arrKanji[indexPath.row])
            return cell
        case .NhatViet:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as CellListTuDien
            cell.configNhatViet(obj: arrTuDien[indexPath.row])
            return cell
        case .VietNhat:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as CellListTuDien
            cell.configVietNhat(obj: arrTuDien[indexPath.row])
            return cell
        case .NguPhap:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as CellListTuDien
            cell.configGammar(obj: arrTuDien[indexPath.row])
            return cell
        default:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as CellListTuDien
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailTuDienVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
