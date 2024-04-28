//
//  ViewController.swift
//  Project4
//
//  Created by Yernar Baiginzheyev on 28.04.2024.
//

import UIKit
import WebKit

class ViewController: UIViewController {

    var webView: WKWebView!
    
    override func loadView() {
        super.loadView()
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "open",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(openTapped))
        
        let url = URL(string: "https://www.hackingwithswift.com")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        
        
    }
    
    @objc private func openTapped() {
        let ac = UIAlertController(title: "Open page..",
                                   message: nil,
                                   preferredStyle: .actionSheet)
        ac.addAction(.init(title: "apple.com", style: .default, handler: openPage))
        ac.addAction(.init(title: "hackingwithswift.com", style: .default, handler: openPage))
        ac.addAction(.init(title: "Cancel", style: .cancel, handler: nil))
        ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    
    private func openPage(action: UIAlertAction) {
        let url = URL(string: "https://\(action.title!)")
        webView.load(URLRequest(url: url!))
    }
    
}

extension ViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
}

