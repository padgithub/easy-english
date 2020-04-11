//
//  SoundManager.swift
//  EasyJapanese
//
//  Created by Phung Anh Dung on 4/7/20.
//  Copyright © 2020 Anh Dũng. All rights reserved.
//

import Foundation
import AVFoundation

enum TypeSound: String {
    case mp3 = "mp3"
    case m4a = "m4a"
}

class SoundManager: NSObject {
    
    static let shared = SoundManager()
    
    var player: AVAudioPlayer?

    func playSound(_ name: String, type: TypeSound = .mp3) {
        guard let url = Bundle.main.url(forResource: name, withExtension: type.rawValue) else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            /* iOS 10 and earlier require the following line:
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */

            guard let player = player else { return }

            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
}
