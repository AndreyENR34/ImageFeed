//
//  ImageCell.swift
//  ImageFeed
//
//  Created by Andrey Nikolaev on 07.03.2023.
//

import Foundation
import UIKit

final class ImagesListCell: UITableViewCell {

  
    @IBOutlet var imageCell: UIImageView!
    
    @IBOutlet var dateLabel: UILabel!
    
    @IBOutlet var likeButton: UIButton!
    
    @IBAction func likeButton(_ sender: Any) {
    }
    
    
    
    static let reuseIdentifier = "ImagesListCell"
}
