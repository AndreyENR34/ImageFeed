//
//  TabBarViewController.swift
//  ImageFeed
//
//  Created by Andrey Nikolaev on 13.09.2023.
//


import UIKit

final class TabBarViewController {
    
    
    func switchToTabBarController() {
        
        guard let window = UIApplication.shared.windows.first else {fatalError("Invalid Configuration")}
        
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        
        window.rootViewController = tabBarController
    }
    
}

