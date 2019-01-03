//
//  DropBoxUITB.swift
//  Real Estate
//
//  Created by Anh Dũng on 12/24/18.
//  Copyright © 2018 Hoa. All rights reserved.
//

import UIKit

class DropBoxUITB: UIView {
    
    var arrData = [String]()
    var handleSelect: ((Int) -> Void)?
    
    @IBOutlet weak var tabView: UITableView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeSubviews()
    }
    
    func initializeSubviews() {
        let xibFileName = "DropBoxUITB" // xib extention not included
        let view = Bundle.main.loadNibNamed(xibFileName, owner: self, options: nil)?[0] as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tabView.delegate = self
        tabView.dataSource = self
    }
}

extension DropBoxUITB: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.attributedText = NSAttributedString(string: arrData[indexPath.row], attributes: [NSAttributedString.Key.font : UIFont(name: "MyriadPro-Regular", size: 12) as Any])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 36*heightRatio
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        handleSelect?(indexPath.row)
    }
    
}


