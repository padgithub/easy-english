//
//  ListModelPlaylistView.swfit
//  EasyEnglish
//
//  Created by Anh Dũng on 12/30/18.
//  Copyright © 2018 Anh Dũng. All rights reserved.
//

import UIKit

class ListModelPlaylistView: NSObject {
    var arrData: [Playlist]
    var handleSelectRow: ((Int) -> Void)?
    
    override init() {
        arrData = []
    }
    
    init(_ arrData : [Playlist]) {
        self.arrData = arrData
    }
}

extension ListModelPlaylistView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as VideoPlayCell
        cell.configCell(playlist: arrData[indexPath.row])
        return cell
    }
}

extension ListModelPlaylistView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115*heightRatio
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        handleSelectRow?(indexPath.row)
    }
}
