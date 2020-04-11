//
//  FlashCardVC.swift
//  EasyJapanese
//
//  Created by Phung Anh Dung on 4/11/20.
//  Copyright © 2020 Anh Dũng. All rights reserved.
//

import UIKit

class FlashCardVC: BaseVC {

    @IBOutlet weak var adView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var navi: NavigationView!
    
    var level = 0
    var arrKanji = [KanjiBaseObj]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navi.handleBack = {
            self.clickBack()
        }
        arrKanji = KanjiManager.shared.fetchAllDataWithLevel(level)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ItemFlashCard.self)
        collectionView.reloadData()
        
        GCDCommon.mainQueue {
            AdmobManager.shared.addBannerInView(view: self.adView, inVC: self)
        }
    }
}

extension FlashCardVC: UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrKanji.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(forIndexPath: indexPath) as ItemFlashCard
        let obj = arrKanji[indexPath.item]
        item.lblKanji.text = obj.kanji
        item.lblDetail.text = "\(obj.kanji)\n\(obj.hanviet)\n\(obj.meaning)\n\(obj.kunyomi)"
        item.viewContents.backgroundColor = .random()
        return item
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
