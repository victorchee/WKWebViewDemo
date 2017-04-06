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
        
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = WKUserContentController()
        configuration.userContentController.add(self, name: "iOSNative")
        let webView = WKWebView(frame: view.bounds, configuration: configuration)
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

        let test = Bundle.main.url(forResource: "Test", withExtension: "html")
        do {
            let html = try String(contentsOf: test!)
            webView.loadHTMLString(html, baseURL: nil)
            
            webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
            webView.addObserver(self, forKeyPath: "title", options: .new, context: nil)
        } catch {
            
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let keyPath = keyPath {
            if keyPath == "estimatedProgress" {
                progressView.progress = change?[NSKeyValueChangeKey.newKey] as? Float ?? 0
            } else if keyPath == "title" {
                self.navigationItem.title = change?[NSKeyValueChangeKey.newKey] as? String ?? ""
            }
        }
    }
}

extension ViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .linkActivated {
            UIApplication.shared.openURL(navigationAction.request.url!)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("webView did commit navigation : \(navigation)")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("webView did finish navigation: \(navigation)")
        webView.evaluateJavaScript("show('abc')") { (response, error) in
            print(response as Any)
        }
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
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Confirm", style: .default) { (action) in
            completionHandler()
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func webViewDidClose(_ webView: WKWebView) {
        print("webView did close")
    }
}

extension ViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "iOSNative" {
            print(message.body)
        }
    }
}
