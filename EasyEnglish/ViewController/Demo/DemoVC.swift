//
//  DemoVC.swift
//  EasyEnglish
//
//  Created by Phung Anh Dung on 1/15/20.
//  Copyright © 2020 Anh Dũng. All rights reserved.
//

import UIKit
import YouTubePlayer

class DemoVC: BaseVC {
    @IBOutlet weak var viewPlayer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewPlayer.addSubview(viewPlay)
        viewPlay.translatesAutoresizingMaskIntoConstraints = false
        viewPlay.frame = viewPlayer.frame
        
    }

    @IBAction func actionLoad(_ sender: Any) {
        viewPlay.playerVars = [
                   "playsinline": "1",
                   "controls": "0",
                   "showinfo": "0"
                   ] as YouTubePlayerView.YouTubePlayerParameters
               viewPlay.loadVideoID("pDmvctJIUsQ")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

class ABC: NSObject {
    static let share = ABC()
    
    let viewPlay = YouTubePlayerView()
}

let viewPlay = ABC.share.viewPlay
