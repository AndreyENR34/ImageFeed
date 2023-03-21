//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Andrey Nikolaev on 11.03.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    let profileImage = UIImage(named: "profileImage")
    
    let emailLabel = UILabel()
    let email = "@ekaterina_nov"
    
    let nameLabel = UILabel()
    let name = "Екатерина Новикова"

    let statusLabel = UILabel()
    let status = "Hello, world!"
    
    let logOutButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showPhotoView()
        showEmailLabel()
        showNameLabel()
        showStatusLabel()
        showlogOutButton()
    }
    
   private func showPhotoView() {
        let profilePhotoView = UIImageView(image: profileImage)
        view.addSubview(profilePhotoView)
        profilePhotoView.translatesAutoresizingMaskIntoConstraints = false
       NSLayoutConstraint.activate([
        profilePhotoView.topAnchor.constraint(equalTo: view.topAnchor, constant: 76),
        profilePhotoView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
        profilePhotoView.heightAnchor.constraint(equalToConstant: 70),
        profilePhotoView.widthAnchor.constraint(equalToConstant: 70)
        ])
    }
    
   private func showEmailLabel() {
        view.addSubview(emailLabel)
        emailLabel.textColor = UIColor(named: "YPGrey")
        emailLabel.text = email
        emailLabel.font = UIFont(name: "SFPro-Regular", size: 13)
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
       NSLayoutConstraint.activate([
        emailLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
        emailLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 180)
        ])
    }
    
   private func showNameLabel() {
        view.addSubview(nameLabel)
        nameLabel.textColor = UIColor(named: "YPWhite")
        nameLabel.text = name
        nameLabel.font = UIFont(name: "SFPro-Bold", size: 23)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
       NSLayoutConstraint.activate([
        nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
        nameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 154)
        ])
    }
    
    private func showStatusLabel() {
        view.addSubview(statusLabel)
        statusLabel.textColor = UIColor(named: "YPWhite")
        statusLabel.text = status
        statusLabel.font = UIFont(name: "SFPro-Regular", size: 13)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
        statusLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 206),
        statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }
    
    private func showlogOutButton() {
        view.addSubview(logOutButton)
        logOutButton.setImage(UIImage(systemName: "ipad.and.arrow.forward"), for: .normal)
        logOutButton.addTarget(self, action: #selector(logOutButtonTouch), for: .touchUpInside)
        logOutButton.translatesAutoresizingMaskIntoConstraints = false
        logOutButton.tintColor = UIColor(named: "YPRed")
        NSLayoutConstraint.activate([
        logOutButton.widthAnchor.constraint(equalToConstant: 20),
        logOutButton.heightAnchor.constraint(equalToConstant: 22),
        logOutButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
        logOutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -26)
        ])
    }
    
    @objc
    private func logOutButtonTouch(_ sender: Any) {
        
    }
    
}
