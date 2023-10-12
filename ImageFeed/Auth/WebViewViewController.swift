//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Andrey Nikolaev on 01.04.2023.
//

import UIKit
import WebKit


fileprivate let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"

final class WebViewViewController: UIViewController  {
    
    
    @IBOutlet private var UIprogressView: UIProgressView!

    @IBOutlet private var webView: WKWebView!
    
    weak var delegate: WebViewViewControllerDelegate?
    
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
             options: [],
             changeHandler: {[weak self] _, _ in
                 guard let self = self else { return }
                 self.updateProgress()
             })
        
        webView.navigationDelegate = self
        
        var urlComponents = URLComponents(string: UnsplashAuthorizeURLString)!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: AccessKey),
            URLQueryItem(name: "redirect_uri", value: RedirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: AccessScope)
        ]
        let url = urlComponents.url!
        
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    
    @IBAction func didTapButton(_ sender: Any) {
        delegate?.webViewViewControllerDidCancel(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    private func updateProgress() {
        UIprogressView.progress = Float(webView.estimatedProgress)
        UIprogressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }    
    
    func code(from navigationAction: WKNavigationAction) -> String? {
        if
            let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == "code"})
                
        {
            OAuth2Service().lastCode = codeItem.value
            return codeItem.value
        } else {
            return nil
        }
    }
    
}
extension WebViewViewController: WKNavigationDelegate    {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
}

protocol WebViewViewControllerDelegate: AnyObject  {
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    
    func webViewViewControllerDidCancel(_ vc:WebViewViewController)
}

