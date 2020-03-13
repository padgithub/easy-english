//
//  MenuVC.swift
//  CNPM
//
//  Created by Luy Nguyen on 12/1/18.
//  Copyright © 2018 Luy Nguyen. All rights reserved.
//

import UIKit
import MessageUI
import StoreKit

@available(iOS 10.3, *)

class MenuObj: NSObject {
    var img: UIImage
    var title: String
    
    init(_ img: UIImage, title: String) {
        self.img = img
        self.title = title
    }
}

class MenuVC: UIViewController {
    @IBOutlet weak var lblVersion: KHLabel!
    @IBOutlet weak var tbMain: UITableView!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lbName: KHLabel!
    @IBOutlet weak var lbEmail: KHLabel!
    @IBOutlet weak var lbTitleLogo: KHLabel!
    
    var arrItem: [MenuObj] = {
        let items: [MenuObj] = [MenuObj(#imageLiteral(resourceName: "ic_bb_home"), title: "txt_home".localized),
                                MenuObj(#imageLiteral(resourceName: "ic_bb_trengding"), title: "txt_catalogue".localized),
                                MenuObj(#imageLiteral(resourceName: "ic_bb_favorite"), title: "txt_favorites".localized),
                                MenuObj(#imageLiteral(resourceName: "ic_bb_libray"), title: "txt_library".localized),
                                MenuObj(#imageLiteral(resourceName: "ic_like_bar"), title: "txt_st_star_app".localized),
                                MenuObj(#imageLiteral(resourceName: "ic_share"), title: "txt_st_share".localized)]
        
        return items
    }()
    let indicator = UIActivityIndicatorView(style: .white)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        self.initData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
}

extension MenuVC {
    func initUI() {
        tbMain.register(MenuCell.self)
//        indicator.frame = CGRect(x: 0, y: 0, width: 46, height: 46)
//        indicator.center = imgAvatar.center
//        imgAvatar.addSubview(indicator)
//        indicator.startAnimating()
        let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
        lblVersion.text = "v\(appVersion ?? "1.0.0")"
    }

    func initData() {

        tbMain.reloadData()
        tbMain.selectRow(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .none)
    }
    
}

extension MenuVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as MenuCell
        cell.config(arrItem[indexPath.item])
        return cell
    }
    
    
}

extension MenuVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return isIPad ? 70 : 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.item {
        case 0:
            let navi = UINavigationController(rootViewController: TAppDelegate.initTabVC(0))
            navi.isNavigationBarHidden = true
            TAppDelegate.menuContainerViewController?.centerViewController = navi
            break
        case 1:
            let navi = UINavigationController(rootViewController: TAppDelegate.initTabVC(1))
            navi.isNavigationBarHidden = true
            TAppDelegate.menuContainerViewController?.centerViewController = navi
            break
        case 2:
            let navi = UINavigationController(rootViewController: TAppDelegate.initTabVC(2))
            navi.isNavigationBarHidden = true
            TAppDelegate.menuContainerViewController?.centerViewController = navi
            break
        case 3:
            let navi = UINavigationController(rootViewController: TAppDelegate.initTabVC(3))
            navi.isNavigationBarHidden = true
            TAppDelegate.menuContainerViewController?.centerViewController = navi
            break
        case 4:
            TAppDelegate.menuContainerViewController?.setMenuState(MFSideMenuStateClosed, completion: nil)
            AppStoreReviewManager.requestReviewNow()
            break
        case 5:
            TAppDelegate.menuContainerViewController?.setMenuState(MFSideMenuStateClosed, completion: nil)
            if let link = NSURL(string: "https://itunes.apple.com/app/id1479709335")
            {
                let mes = "Learn Japanese by video - Good apps for everyone to download"
                let objectsToShare = [mes,link] as [Any]
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                activityVC.excludedActivityTypes = [.postToFacebook,.postToTwitter,.copyToPasteboard,.message,.mail, .addToReadingList]
                activityVC.popoverPresentationController?.sourceView = self.view
                activityVC.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
                activityVC.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                self.present(activityVC, animated: true) {
                    print("option menu presented")
                }
            }
            break
        default:
            
            break
        }
    }
    
    func actionSupport() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["tueanhoang.devios2011@gmail.com"])
            mail.setSubject("Regarding")
            
            present(mail, animated: true)
        } else {
            Common.showAlert("Mail services are not available")
        }
    }
    
    func actionShare() {
        let text = [ "http://itunes.apple.com/app/id" + "appId" ]
        let activityViewController = UIActivityViewController(activityItems: text , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
}

extension MenuVC {
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                self.imgAvatar.image = UIImage(data: data)
                self.indicator.stopAnimating()
            }
        }
    }
}


extension MenuVC: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}