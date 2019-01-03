//
//  ZoomOutViewPlayVideo.swift
//  EasyEnglish
//
//  Created by Anh Dũng on 1/3/19.
//  Copyright © 2019 Anh Dũng. All rights reserved.
//

import UIKit

class ZoomOutViewPlayVideo: UIView {
    
    @IBOutlet weak var viewPlayer: UIView!
    
    var viewPlayss = VideoServiceView.shared.viewPlayer
    
    var handleReturnView:(() -> Void)?
    var handleRemoveView:(() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initializeSubviews() {
        let xibFileName = "ZoomOutViewPlayVideo" // xib extention not included
        let view = Bundle.main.loadNibNamed(xibFileName, owner: self, options: nil)?[0] as! UIView
        view.frame = self.bounds
        self.addSubview(view)
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func actionReturnView(_ sender: Any) {
        handleReturnView?()
    }
    
    @IBAction func actionRemoveView(_ sender: Any) {
        handleRemoveView?()
    }
}

extension ZoomOutViewPlayVideo {
    
    func addSubViewVideo() {
        viewPlayss.removeFromSuperview()
        viewPlayss.translatesAutoresizingMaskIntoConstraints = false
        viewPlayer.addSubview(viewPlayss)
        frameViewPlay(viewPlayer)
    }
    
    func frameViewPlay(_ view : UIView) {
        viewPlayss.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        viewPlayss.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        viewPlayss.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        viewPlayss.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    }
}
