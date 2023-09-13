//
//  TabBarViewController.swift
//  ImageFeed
//
//  Created by Andrey Nikolaev on 13.09.2023.
//

import Foundation
import UIKit

final class TabBarController {
    
    
    func switchToTabBarController() {
        
        guard let window = UIApplication.shared.windows.first else {fatalError("Invalid Configuration")}
        
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        
        window.rootViewController = tabBarController
    }
    
}
