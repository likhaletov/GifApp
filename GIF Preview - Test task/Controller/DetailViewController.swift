//
//  DetailViewController.swift
//  GIF Preview - Test task
//
//  Created by Dmitry Likhaletov on 11.07.2020.
//  Copyright © 2020 Dmitry Likhaletov. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    
    var webView: WKWebView!
    let url: URL?
    let id: String?
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.isOpaque = false
        
        guard let url = url, let title = id else { return }
        navigationItem.title = title
        
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    deinit {
        print("deallocated")
    }
    
    init(with url: URL, and id: String) {
        self.url = url
        self.id = id
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension DetailViewController: WKUIDelegate {
    
}
