//
//  WebViewController.swift
//  WordTrotter2
//
//  Created by Dylan Welch on 2/23/21.
//  Copyright © 2021 Dylan Welch. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, UIWebViewDelegate {
    
    var webView: WKWebView!
    
    override func loadView() {
        super.viewDidLoad()
        webView = WKWebView()
        
        view = webView
        
        let url = URL(string: "https://www.bignerdranch.com")
        let urlRequest = URLRequest(url: url! as URL)
        webView.load(urlRequest as URLRequest)
    
        print("Web view loaded")
    }
    
}
