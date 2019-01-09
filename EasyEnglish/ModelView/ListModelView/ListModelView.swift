//
//  ListModelView.swift
//  EasyEnglish
//
//  Created by Anh Dũng on 12/30/18.
//  Copyright © 2018 Anh Dũng. All rights reserved.
//

import UIKit

class ListModelView: NSObject {
    var arrData: [Items]
    var handleSelectRow: ((Int) -> Void)?
    var isPlaylist = false
    
    override init() {
        arrData = []
    }
    
    init(_ arrData : [Items]) {
        self.arrData = arrData
    }
}

extension ListModelView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isPlaylist {
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as VideoPlayCell
            cell.configCell(video: arrData[indexPath.row])
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as VideoHomeCell
            return cell
        }
    }
}

extension ListModelView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return isPlaylist ? 115*heightRatio : 300*heightRatio //125
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        handleSelectRow?(indexPath.row)
    }
}
