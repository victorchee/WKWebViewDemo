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
        webView.UIDelegate = self
        view.insertSubview(webView, belowSubview: progressView)
        
        // Layout
        webView.translatesAutoresizingMaskIntoConstraints = false
        let views: [String : AnyObject] = ["webView" : webView, "topLayoutGuide" : topLayoutGuide]
        var constraints = [NSLayoutConstraint]()
        let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[webView]|", options: [], metrics: nil, views: views)
        constraints += horizontalConstraints
        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[topLayoutGuide][webView]|", options: [], metrics: nil, views: views)
        constraints += verticalConstraints
        NSLayoutConstraint.activateConstraints(constraints)
        
        webView.loadRequest(NSURLRequest(URL: NSURL(string: "https://victorchee.github.io")!))
        
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if let keyPath = keyPath where keyPath == "estimatedProgress" {
            progressView.progress = change?["new"] as? Float ?? 0
        }
    }
}

extension ViewController: WKNavigationDelegate {
    func webView(webView: WKWebView, didCommitNavigation navigation: WKNavigation!) {
        print("webView did commit navigation : \(navigation)")
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        print("webView did finish navigation: \(navigation)")
    }
    
    func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError) {
        print("webView did fail navigation: \(navigation) with error: \(error.localizedDescription)")
    }
    
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("webView did start provisional navigation: \(navigation)")
    }
    
    func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        print("webView did fail provisional navigation: \(navigation)")
    }
}

extension ViewController: WKUIDelegate {
    func webView(webView: WKWebView, createWebViewWithConfiguration configuration: WKWebViewConfiguration, forNavigationAction navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        print("webView create web view with configuration: \(configuration)")
        return webView
    }
    
    func webViewDidClose(webView: WKWebView) {
        print("webView did close")
    }
}