//
//  ListTuDienVC.swift
//  EasyEnglish
//
//  Created by Phung Anh Dung on 4/27/20.
//  Copyright © 2020 Anh Dũng. All rights reserved.
//

import UIKit
import DGElasticPullToRefresh

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
    var page = 0
    var keyword = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CellListTuDien.self)
        tableView.register(CellListKanji.self)
        initData()
        Timer.after(0.5) {
            self.initRefesh()
        }
    }
    
    func initRefesh() {
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()

        loadingView.tintColor = UIColor(red: 78/255.0, green: 221/255.0, blue: 200/255.0, alpha: 1.0)

        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1.2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                self!.refesh()
            })
            }, loadingView: loadingView)

        tableView.dg_setPullToRefreshFillColor(UIColor(red: 57/255.0, green: 67/255.0, blue: 89/255.0, alpha: 1.0))
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)

        tableView.addInfiniteScrolling {
            self.loadData()
            self.tableView.infiniteScrollingView.stopAnimating()
        }
    }
    
    deinit {
    }
    
    func initData() {
        switch type {
        case .Kanji:
            arrKanji = KanjiManager.shared.fetchAllDataWithLevel(1)
        case .NhatViet:
            arrTuDien.append(contentsOf: NhatVietManager.shared.fetchAllDataWithKeyword(keyword,page))
        case .VietNhat:
            arrTuDien.append(contentsOf: VietNhatManager.shared.fetchAllDataWithKeyword(keyword,page))
        case .NguPhap:
            arrTuDien.append(contentsOf: NguPhapManager.shared.fetchAllDataWithKeyword(keyword,page))
        default:
            break
        }
        tableView.reloadData()
    }
    
    func refesh() {
        page = 0
        arrTuDien.removeAll()
        initData()
        tableView.dg_stopLoading()
    }
    
    func loadData() {
        page = page + 1
        initData()
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
        switch type {
        case .Kanji:
            let vc = DetailKanjiVC()
            vc.kanjiModel = arrKanji[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
            break
        default:
            let vc = DetailTuDienVC()
            vc.typeList = type
            vc.tudienObj = arrTuDien[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}
