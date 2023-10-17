//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Andrey Nikolaev on 12.09.2023.
//

import UIKit


final class SplashViewController: UIViewController {
    
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private  let ShowAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreenSegueIdentifier"
    
    var splashViewImage = UIImage(named: "splash_screen_logo")
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        showSplashImageView()
        
        
        
        if  OAuth2TokenStorage().token == "" {
            let storyboard = UIStoryboard(name: "Main", bundle: .main)
            guard let AuthViewController = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController else {return}
            AuthViewController.modalPresentationStyle = .fullScreen
            AuthViewController.delegate = self
            present(AuthViewController, animated: true)
            
            
        } else {
            self.fetchProfile(token: OAuth2TokenStorage().token!)
            TabBarController().switchToTabBarController()
        }
    }
    
    private func showSplashImageView() {
        let splashImageView = UIImageView(image: splashViewImage)
        view.addSubview(splashImageView)
        splashImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            splashImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            splashImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
        ])
    }
}



extension SplashViewController {
    func showNetworkError() {
        
        
        let alert = UIAlertController(title: "Что-то пошло не так(",
                                      message: "Не удалось войти в систему",
                                      preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(action)
        
        presentedViewController?.present(alert, animated: true)
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
            guard let self else { return }
            switch result {
                
            case .success(let result):
                OAuth2TokenStorage().token = result
                OAuth2Service().lastCode = nil
                OAuth2Service().fetchOneWork = false
                UIBlockingProgressHUD.dismiss()
                self.fetchProfile(token: result)
                
            case .failure(_):
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
                guard let userName = profile.userName else {
                    return}
                ProfileImageService.shared.fetchProfileImageURL(userName: userName) { [weak self] result in
                    
                    switch result {
                    case .success(_):
                        self?.profileImageService.fetchProfileImageOneWork = false
                        
                        
                        
                        
                    case .failure:
                        break
                    }
                }
                UIBlockingProgressHUD.dismiss()
                TabBarController().switchToTabBarController()
            case .failure(_):
                UIBlockingProgressHUD.dismiss()
                
                break
            }
        }
    }
}






