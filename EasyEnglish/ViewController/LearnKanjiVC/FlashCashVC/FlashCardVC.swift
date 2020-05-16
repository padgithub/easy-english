//
//  FlashCardVC.swift
//  EasyJapanese
//
//  Created by Phung Anh Dung on 4/11/20.
//  Copyright © 2020 Anh Dũng. All rights reserved.
//

import UIKit

class FlashCardVC: BaseVC {

    @IBOutlet weak var imRandom: KHImageView!
    @IBOutlet weak var imRepea: KHImageView!
    @IBOutlet weak var tfTime: KHTextField!
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var adView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var navi: NavigationView!
    @IBOutlet weak var ctrHeightToolBar: NSLayoutConstraint!
    
    var timeInval = Timer()
    var level = 0
    var arrKanji = [KanjiBaseObj]()
    var indexCurrent = 0
    
    var isAutoScroll: Bool = false {
        didSet {
            if isAutoScroll {
                startTimer()
            }else{
                timeInval.invalidate()
            }
            imRepea.backgroundColor = isAutoScroll ? UIColor("73FA79", alpha: 1) : .clear
        }
    }
    
    var isShuffled: Bool = false {
        didSet {
            if isShuffled {
                arrKanji = arrKanji.shuffled()
                collectionView.reloadData()
                indexCurrent = 0
                resetCount()
            }else{
                arrKanji = KanjiManager.shared.fetchAllDataWithLevel(level)
                collectionView.reloadData()
                indexCurrent = 0
                resetCount()
            }
            imRandom.backgroundColor = isShuffled ? UIColor("73FA79", alpha: 1) : .clear
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navi.handleBack = {
            self.clickBack()
        }
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ItemFlashCard.self)
        isAutoScroll = false
        isShuffled = false
        GCDCommon.mainQueue {
            AdmobManager.shared.addBannerInView(view: self.adView, inVC: self)
        }
        ctrHeightToolBar.constant = isIPad ? 90 : 60
        resetCount()
    }
    
    @IBAction func actionAuto(_ sender: Any) {
        isAutoScroll = !isAutoScroll
    }
    
    @IBAction func actionShuff(_ sender: Any) {
        isShuffled = !isShuffled
    }
    
    func resetCount() {
        lblCount.text = "\(indexCurrent + 1)\\\(arrKanji.count)"
    }
    
    func startTimer() {
        timeInval =  Timer.scheduledTimer(timeInterval: TimeInterval.init(Double(tfTime.text ?? "1") ?? 1), target: self, selector: #selector(self.autoScroll), userInfo: nil, repeats: true)
    }
    
    
    @objc func autoScroll() {
        if self.indexCurrent < arrKanji.count {
            let indexPath = IndexPath(item: indexCurrent, section: 0)
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            self.indexCurrent = self.indexCurrent + 1
        } else {
            self.indexCurrent = 0
            self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: true)
        }
        resetCount()
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
        item.lblDetail.text = "\(obj.kanji ?? "")\n\n\(obj.hanviet ?? "")\n\n\(obj.meaning ?? "")\n\n\(obj.kunyomi ?? "")\n\n\(obj.onyomi ?? "")"
        item.viewDetail.isHidden = true
        item.viewKanji.isHidden = false
        item.viewContents.backgroundColor = .random()
        item.handleActionDetail = {
            let vc = DetailKanjiVC()
            vc.kanjiModel = self.arrKanji[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
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
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var visibleRect = CGRect()

        visibleRect.origin = collectionView.contentOffset
        visibleRect.size = collectionView.bounds.size

        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)

        guard let indexPath = collectionView.indexPathForItem(at: visiblePoint) else { return }
        indexCurrent = indexPath.item
        resetCount()
        print(indexPath)
    }
}
