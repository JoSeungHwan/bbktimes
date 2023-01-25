//
//  joinViewController.swift
//  bbktimes
//
//  Created by 조승환 on 2023/01/02.
//

import Foundation
import UIKit
import WebKit

class joinViewController: UIViewController {
    
    @IBOutlet var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webViewInit()
    }
    
    func webViewInit() {
        WKWebsiteDataStore.default().removeData(ofTypes: [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache],modifiedSince: Date(timeIntervalSince1970: 0)) {
        }
        //                webView.uiDelegaㅛㅛonDelegate = self
        
        webView.allowsBackForwardNavigationGestures = true
        
        if let url = URL(string: "https://bbktimes.co.kr/member/write.php"){
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    @IBAction func dismissBtn(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true)
    }
    
}
