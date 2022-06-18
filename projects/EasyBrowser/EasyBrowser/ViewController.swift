//
//  ViewController.swift
//  EasyBrowser
//
//  Created by Yi An Chen on 2022/4/1.
//

import UIKit
import WebKit

// Key value observing, KVO: tell me when the property X of object Y gets changed by anyone at any time

// ViewController is a UIViewController, and it confrom to WKNavigationDelegate

class ViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var progressView: UIProgressView!
    var website = ""
//    var websites = ["apple.com", "hackingwithswift.com"]
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self // when any webpage navigation happenes, please tell me the current viewController
        // delegate is one thing acting in place of another, effectively answering questions, and responding to events on its behalf
        // WKWebView doesn't know, or doesn't care how our application wan't to behave, because that's our custom code
        // delecation can tell WKWebView, we want to be informed when something interesting happenes
        
        // when using delegate, we need
        // must conform to the required protocol (while navigationDelete protocol method are all optional, but swift doesn't know this thing)
        
        view = webView
        
        navigationItem.largeTitleDisplayMode = .never
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        let back = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(goBack))
        let forward = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(goForward))
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        
        toolbarItems = [back, progressButton, forward, spacer, refresh]
        navigationController?.isToolbarHidden = false
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        
        let url = URL(string: "https://" + website)!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    @objc func goBack() {
        if webView.canGoBack {
            webView.goBack()
        }
    }
    
    @objc func goForward() {
        if webView.canGoForward {
            webView.goForward()
        }
    }
    
//    @objc func openTapped() {
//        let ac = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
//
//        for website in websites {
//            ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
//        }
//
//        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
//        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem // for iPad
//        present(ac, animated: true)
//    }
    
    func openPage(action: UIAlertAction! = nil) {
        guard let actionTitle = action.title else { return }
        guard let url = URL(string: "https://" + actionTitle) else { return }
        
//        let url = URL(string: "https://" + action.title!)!
        webView.load(URLRequest(url: url))
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if let webTitle = webView.title {
            if webTitle.isEmpty == false {
                title = webView.title
            }
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    // @escaping means this closure is potential to escape the current method and be used at a later date
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        let isSourceMain = navigationAction.sourceFrame.isMainFrame
        
        guard let host = url?.host else {
            decisionHandler(.allow)
            return
        }
        
        if host.contains(website) || !isSourceMain {
            decisionHandler(.allow)
            return
        }
        
        decisionHandler(.cancel)
        
        let ac = UIAlertController(title: "External Website", message: "You can't go to another website", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
}

