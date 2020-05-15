//
//  BrowserViews.swift
//  NgheTiengAnhDoiThuong
//
//  Created by Phung Anh Dung on 5/10/20.
//  Copyright © 2020 Phung Anh Dung. All rights reserved.
//

import UIKit
import WebKit

class BrowserViews: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnForward: UIButton!
    
    var urls = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        updateButton()
        
        webView.load(URLRequest.init(url: URL.init(string: urls) ?? URL.init(string: "https://google.com/search?q=\(urls.encode())")!))
    }
    
    @IBAction func actionDissmis(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func actionBack(_ sender: Any) {
        if (self.webView.canGoBack) {
            self.webView.goBack()
        }
    }
    
    @IBAction func actionFoward(_ sender: Any) {
        if (self.webView.canGoForward) {
            self.webView.goForward()
        }
    }
    
    @IBAction func actionMore(_ sender: Any) {
    }
    
    func updateButton() {
        btnBack.isEnabled = webView.canGoBack
        btnForward.isEnabled = webView.canGoForward
    }
    
    func stringByEvaluatingJavaScript(from script: String) -> String? {
        var resultString: String? = nil
        var finished = false

        webView.evaluateJavaScript(script, completionHandler: { result, error in
            if error == nil {
                if result != nil {
                    if let result = result {
                        resultString = "\(result)"
                    }
                }
            } else {
                print("evaluateJavaScript error : \(error?.localizedDescription ?? "")")
            }
            finished = true
        })

        while !finished {
            RunLoop.current.run(mode: .default, before: Date.distantFuture)
        }

        return resultString
    }

}

extension BrowserViews: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        lblTitle.text = "Loading..."
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        lblTitle.text = "This site can’t be reached"
        updateButton()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        updateButton()
        let title = stringByEvaluatingJavaScript(from: "document.title")
        lblTitle.text = title
    }
}
