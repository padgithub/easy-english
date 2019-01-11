//
//  ListNoteModelView.swift
//  EasyEnglish
//
//  Created by Anh Dũng on 1/11/19.
//  Copyright © 2019 Anh Dũng. All rights reserved.
//

import UIKit

class ListNoteModelView: NSObject {
    
    var arrData: [Items]
    var handleSelectRow: ((Int) -> Void)?
    
    override init() {
        arrData = []
    }
    
    init(_ arrData : [Items]) {
        self.arrData = arrData
    }
}

extension ListNoteModelView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as NotesCell
        cell.selectionStyle = .none
        cell.configCell(self.arrData[indexPath.row])
        return cell
    }
}

extension ListNoteModelView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        handleSelectRow?(indexPath.row)
    }
}
