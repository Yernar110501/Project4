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
    var progresView: UIProgressView!
    var websites = ["apple.com", "hackingwithswift.com"]
    
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
        
        progresView = UIProgressView(progressViewStyle: .default)
        progresView.sizeToFit()
        let progresButton = UIBarButtonItem(customView: progresView)
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        
        toolbarItems = [progresButton, spacer, refresh]
        navigationController?.isToolbarHidden = false
        
        let url = URL(string: "https://\(websites[0])")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progresView.progress = Float(webView.estimatedProgress)
        }
    }
    
    @objc private func openTapped() {
        let ac = UIAlertController(title: "Open page..",
                                   message: nil,
                                   preferredStyle: .actionSheet)
        websites.forEach{
            ac.addAction(.init(title: $0, style: .default, handler: openPage))
        }
        ac.addAction(.init(title: "Cansel", style: .cancel, handler: nil))
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
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        
        if let host = url?.host {
            for website in websites {
                if host.contains(website) {
                    decisionHandler(.allow)
                    return
                }
            }
        }
        
        decisionHandler(.cancel)
        
    }
}

