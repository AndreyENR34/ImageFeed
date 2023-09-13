//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Andrey Nikolaev on 12.09.2023.
//

import UIKit

final class SplashViewController: UIViewController {
    
    
    private  let ShowAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreenSegueIdentifier"
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        if  OAuth2TokenStorage().token == "" {
            
            performSegue(withIdentifier: ShowAuthenticationScreenSegueIdentifier, sender: nil)
            
        } else {
            TabBarController().switchToTabBarController()
        }
    }
    
    
}

extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowAuthenticationScreenSegueIdentifier {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else { fatalError("Failed to prepare for \(ShowAuthenticationScreenSegueIdentifier)")}
            
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
        
    }
}

extension SplashViewController: AuthViewControllerDelegate  {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        dismiss(animated: true) { [weak self] in
            guard let self = self else {return}
            
            OAuth2Service().fetchAuthToken(code, completion: { result in
                
                switch result  {
                case .success(let result):
                    TabBarController()
                    OAuth2TokenStorage().token = result
                case .failure(let error):
                    print("We get error \(error)")
                }
            }
            )
        }
    }
    
}

