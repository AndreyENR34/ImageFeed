//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Andrey Nikolaev on 12.09.2023.
//

import UIKit
import ProgressHUD



final class UIBlockingProgressHUD {
    private static var window: UIWindow? {
        return UIApplication.shared.windows.first
    }
    
    static func show() {
        window?.isUserInteractionEnabled = false
        ProgressHUD.show()
    }
    
    static func dismiss() {
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
}

final class SplashViewController: UIViewController {
    
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    private  let ShowAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreenSegueIdentifier"
    
  
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        
      
        if  OAuth2TokenStorage().token == "" {
            performSegue(withIdentifier: ShowAuthenticationScreenSegueIdentifier, sender: nil)
            
        } else {
            self.fetchProfile(token: OAuth2TokenStorage().token!)
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

extension SplashViewController {
    func showNetworkError() {
        
        
        let alert = UIAlertController(title: "Что-то пошло не так(",
                                     message: "Не удалось войти в систему",
                                      preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(action)
        
            self.present(alert, animated: true)
    }
    }
  


extension SplashViewController: AuthViewControllerDelegate  {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        
        UIBlockingProgressHUD.show()
        dismiss(animated: true) { [weak self] in
            guard let self = self else {return}
            
                    self.fetchOAuthToken(code)
        }
    }
    
    private func fetchOAuthToken(_ code: String) {
        OAuth2Service().fetchAuthToken(code, completion: { [weak self] result in
               guard let self = self else { return }
               switch result {
                   
               case .success(let result):
                   OAuth2TokenStorage().token = result
                   OAuth2Service().lastCode = nil
                   OAuth2Service().fetchOneWork = false
                   UIBlockingProgressHUD.dismiss()
                   TabBarController()
                   self.fetchProfile(token: result)
                
               case .failure(let error):
                   UIBlockingProgressHUD.dismiss()
                    self.showNetworkError()
                   break
               }
           }
        )
       }

    
         func fetchProfile(token: String) {
                profileService.fetchProfile(token) { [weak self] result in
                    switch result {
                    case .success(let profile):
                        self?.profileService.fetchProfileOneWork = false
                        guard let userName = profile.userName else {
                            return}
                        ProfileImageService.shared.fetchProfileImageURL(userName: userName) { [weak self] result in
                            
                            switch result {
                            case .success(let imageURL):
                                self?.profileImageService.fetchProfileImageOneWork = false
                                
                                
                              
                                
                            case .failure:
                                break
                            }
                        }
                        UIBlockingProgressHUD.dismiss()
                        TabBarController().switchToTabBarController()
                    case .failure(let error):
                        UIBlockingProgressHUD.dismiss()
                        
                        break
                    }
                }
            }
        }
        
        
    
    


