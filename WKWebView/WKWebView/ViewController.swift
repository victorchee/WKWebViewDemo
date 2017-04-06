//
//  ViewController.swift
//  WKWebView
//
//  Created by qihaijun on 12/17/15.
//  Copyright © 2015 VictorChee. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    @IBOutlet weak var progressView: UIProgressView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let webView = WKWebView(frame: view.bounds)
        webView.allowsBackForwardNavigationGestures = true
        webView.allowsLinkPreview = true
        webView.navigationDelegate = self;
        webView.uiDelegate = self
        view.insertSubview(webView, belowSubview: progressView)
        
        // Layout
        webView.translatesAutoresizingMaskIntoConstraints = false
        let views: [String : AnyObject] = ["webView" : webView, "topLayoutGuide" : topLayoutGuide]
        var constraints = [NSLayoutConstraint]()
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[webView]|", options: [], metrics: nil, views: views)
        constraints += horizontalConstraints
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[topLayoutGuide][webView]|", options: [], metrics: nil, views: views)
        constraints += verticalConstraints
        NSLayoutConstraint.activate(constraints)
        
        webView.load(URLRequest(url: URL(string: "https://victorchee.github.io")!))
        
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let keyPath = keyPath, keyPath == "estimatedProgress" {
            progressView.progress = change?["new"] as? Float ?? 0
        }
    }
}

extension ViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("webView did commit navigation : \(navigation)")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("webView did finish navigation: \(navigation)")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("webView did fail navigation: \(navigation) with error: \(error.localizedDescription)")
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("webView did start provisional navigation: \(navigation)")
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("webView did fail provisional navigation: \(navigation)")
    }
}

extension ViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        print("webView create web view with configuration: \(configuration)")
        return webView
    }
    
    func webViewDidClose(_ webView: WKWebView) {
        print("webView did close")
    }
}
