//
//  WebViewController.swift
//  ImageFeed
//
//  Created by Andrey Nikolaev on 01.04.2023.
//

import UIKit
import WebKit

final class WebViewViewController: UIViewController  {
    
    fileprivate let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    
    @IBOutlet private var webView: WKWebView!
    
    
    @IBAction private func didTapBackButton(_ sender: Any?) {
    }
    
    weak var delegate: WebViewViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        
        var urlComponents = URLComponents(string: UnsplashAuthorizeURLString)!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: AccessKey),
            URLQueryItem(name: "redirect_uri", value: RedirectURI),
            URLQueryItem(name: "response_type", value: AccessScope)
        ]
        let url = urlComponents.url!
        
        let request = URLRequest(url: url)
        webView.load(request)
        
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if
            let url = navigationAction.request.url,                            //1
            let urlComponents = URLComponents(string: url.absoluteString),     //2
            urlComponents.path == "/oauth/authorize/native",                   //3
            let items = urlComponents.queryItems,                              //4
            let codeItem = items.first(where: { $0.name == "code"})            //5
        {
            return codeItem.value                                              //6
        } else {
            return nil
        }
        
    }
}
extension WebViewViewController: WKNavigationDelegate    {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let code = code(from: navigationAction) {          //1
            //TODO: process code           //2
            decisionHandler(.cancel)  //3
        } else {
            decisionHandler(.allow)   //4
        }
    }
    
}

protocol WebViewViewControllerDelegate: AnyObject  {
    
    func webViewViewController(_vc: WebViewViewController, didAuthenticateWithCode: String)
        
    func webViewViewControllerDidCancel(_vc:WebViewViewController)
}

