//
//  AlphabeVC.swift
//  EasyJapanese
//
//  Created by Phung Anh Dung on 4/7/20.
//  Copyright © 2020 Anh Dũng. All rights reserved.
//

import UIKit

class AlphabeVC: BaseVC {
    
    @IBOutlet weak var adView: UIView!
    @IBOutlet weak var navi: NavigationView!
    @IBOutlet weak var seControll: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var arrDataJ = [String]()
    var arrDataE = [String]()
    
    fileprivate let arrJHiragina = ["あ", "い", "う", "え", "お", "か", "き", "く", "け", "こ", "さ", "し", "す", "せ", "そ", "た", "ち", "つ", "て", "と", "な", "に", "ぬ", "ね", "の", "は", "ひ", "ふ", "へ", "ほ", "ま", "み", "む", "め", "も", "や", "", "ゆ", "", "よ", "ら", "り", "る", "れ", "ろ", "わ", "", "", "", "を", "", "", "", "", "ん", "が", "ぎ", "ぐ", "げ", "ご", "ざ", "じ", "ず", "ぜ", "ぞ", "だ", "ぢ", "づ", "で", "ど", "ば", "び", "ぶ", "べ", "ぼ", "ぱ", "ぴ", "ぷ", "ぺ", "ぽ", "", "", "", "", "", "きゃ", "きゅ", "きょ", "しゃ", "しゅ", "しょ", "ちゃ", "ちゅ", "ちょ", "にゃ", "にゅ", "にょ", "ひゃ", "ひゅ", "ひょ", "みゃ", "みゅ", "みょ", "りゃ", "りゅ", "りょ", "ぎゃ", "ぎゅ", "ぎょ", "じゃ", "じゅ", "じょ", "びゃ", "びゅ", "びょ", "ぴゃ", "ぴゅ", "ぴょ"]
    fileprivate let arrVHiragina = ["a", "i", "u", "e", "o", "ka", "ki", "ku", "ke", "ko", "sa", "shi", "su", "se", "so", "ta", "chi", "tsu", "te", "to", "na", "ni", "nu", "ne", "no", "ha", "hi", "fu", "he", "ho", "ma", "mi", "mu", "me", "mo", "ya", "", "yu", "", "yo", "ra", "ri", "ru", "re", "ro", "wa", "", "", "", "o", "", "", "", "", "n", "ga", "gi", "gu", "ge", "go", "za", "ji", "zu", "ze", "zo", "da", "ji", "zu", "de", "do", "ba", "bi", "bu", "be", "bo", "pa", "pi", "pu", "pe", "po", "", "", "", "", "", "kya", "kyu", "kyo", "sha", "shu", "sho", "cha", "chu", "cho", "nya", "nyu", "nyo", "hya", "hyu", "hyo", "mya", "myu", "myo", "rya", "ryu", "ryo", "gya", "gyu", "gyo", "ja", "ju", "jo", "bya", "byu", "byo", "pya", "pyu", "pyo"]
    
    fileprivate let arrJKatarina = ["ア", "イ", "ウ", "エ", "オ", "カ", "キ", "ク", "ケ", "コ", "サ", "シ", "ス", "セ", "ソ", "タ", "チ", "ツ", "テ", "ト", "ナ", "ニ", "ヌ", "ネ", "ノ", "ハ", "ヒ", "フ", "ヘ", "ホ", "マ", "ミ", "ム", "メ", "モ", "ヤ", "", "ユ", "", "ヨ", "ラ", "リ", "ル", "レ", "ロ", "ワ", "", "", "", "オ", "", "", "", "", "ン", "ガ", "ギ", "グ", "ゲ", "ゴ", "ザ", "ジ", "ズ", "ゼ", "ゾ", "ダ", "ヂ", "ヅ", "デ", "ド", "バ", "ビ", "ブ", "ベ", "ボ", "パ", "ピ", "プ", "ペ", "ポ", "", "", "", "", "", "キャ", "キュ", "キョ", "シャ", "シュ", "ショ", "チャ", "チュ", "チョ", "ニャ", "ニュ", "ニョ", "ヒャ", "ヒュ", "ヒョ", "ミャ", "ミュ", "ミョ", "リャ", "リュ", "リョ", "ギャ", "ギュ", "ギョ", "ジャ", "ジュ", "ジョ", "ビャ", "ビュ", "ビョ", "ピャ", "ピュ", "ピョ"]
    
    fileprivate let arrVKatarina = ["a", "i", "u", "e", "o", "ka", "ki", "ku", "ke", "ko", "sa", "shi", "su", "se", "so", "ta", "chi", "tsu", "te", "to", "na", "ni", "nu", "ne", "no", "ha", "hi", "fu", "he", "ho", "ma", "mi", "mu", "me", "mo", "ya", "", "yu", "", "yo", "ra", "ri", "ru", "re", "ro", "wa", "", "", "", "o", "", "", "", "", "n", "ga", "gi", "gu", "ge", "go", "za", "ji", "zu", "ze", "zo", "da", "ji", "zu", "de", "do", "ba", "bi", "bu", "be", "bo", "pa", "pi", "pu", "pe", "po", "", "", "", "", "","kya", "kyu", "kyo", "sha", "shu", "sho", "cha", "chu", "cho", "nya", "nyu", "nyo", "hya", "hyu", "hyo", "mya", "myu", "myo", "rya", "ryu", "ryo", "gya", "gyu", "gyo", "ja", "ju", "jo", "bya", "byu", "byo", "pya", "pyu", "pyo"];

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navi.handleProfile = {
            self.openMenu()
        }
        
        GCDCommon.mainQueue {
            AdmobManager.shared.addBannerInView(view: self.adView, inVC: self)
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(AlphabeCollectionCell.self)
        
        arrDataJ = arrJHiragina
        arrDataE = arrVHiragina
        collectionView.reloadData()
    }

    @IBAction func didTab(_ sender: Any) {
        switch seControll.selectedSegmentIndex {
        case 0:
            arrDataJ = arrJHiragina
            arrDataE = arrVHiragina
            collectionView.reloadData()
        default:
            arrDataJ = arrJKatarina
            arrDataE = arrVKatarina
            collectionView.reloadData()
        }
    }
    
}

extension AlphabeVC: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrDataJ.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(forIndexPath: indexPath) as AlphabeCollectionCell
        item.lblJP.text = arrDataJ[indexPath.item]
        item.lblEn.text = arrDataE[indexPath.item]
        item.viewShadown.isHidden = arrDataJ[indexPath.item] == ""
        return item
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Playing")
        SoundManager.shared.playSound(arrDataE[indexPath.item])
        AdmobManager.shared.logEvent(true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.size.width / 5 - 5
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    
}
