//
//  UIAlertDelegat.swift
//  ImageFeed
//
//  Created by Andrey Nikolaev on 27.09.2023.
//

import Foundation
import UIKit

protocol UIAlertDelegate: AnyObject {
    func present( _ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?)
}
