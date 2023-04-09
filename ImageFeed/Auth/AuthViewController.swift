//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Andrey Nikolaev on 01.04.2023.
//

import UIKit

final class AuthViewController: UIViewController {
    
    
 private let ShowWebViewSegueIdentifier = "ShowWebView"
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowWebViewSegueIdentifier {
            guard
                let webViewViewController = segue.destination as? WebViewViewController
            else { fatalError("Failed to prepare for \(ShowWebViewSegueIdentifier)")}
            
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_vc: WebViewViewController, didAuthenticateWithCode: String) {
        //TODO: process code
    }
    
    func webViewViewControllerDidCancel(_vc: WebViewViewController) {
        dismiss(animated: true)
    }
    
    
}
