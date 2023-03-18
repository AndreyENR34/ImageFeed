//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Andrey Nikolaev on 11.03.2023.
//

import UIKit



final class ProfileViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        filePhotoView()
        emailLabel()
        nameLabel()
        statusLabel()
        logOutButton()
    }
    
    func filePhotoView() {
        
        let profileImage = UIImage(named: "profileImage")
        let profilePhotoView = UIImageView(image: profileImage)
        view.addSubview(profilePhotoView)
        profilePhotoView.translatesAutoresizingMaskIntoConstraints = false
        profilePhotoView.topAnchor.constraint(equalTo: view.topAnchor, constant: 76).isActive = true
        profilePhotoView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        profilePhotoView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        profilePhotoView.widthAnchor.constraint(equalToConstant: 70).isActive = true
    }
    
    func emailLabel() {
        
        let emailLabel = UILabel()
        view.addSubview(emailLabel)
        emailLabel.textColor = UIColor(named: "YPGrey")
        emailLabel.text = "@ekaterina_nov"
        emailLabel.font = UIFont(name: "SFPro-Regular", size: 13)
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        emailLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 180).isActive = true
      
        
    }
    
    func nameLabel() {
        
        let nameLabel = UILabel()
        view.addSubview(nameLabel)
        nameLabel.textColor = UIColor(named: "YPWhite")
        nameLabel.text = "Екатерина Новикова"
        nameLabel.font = UIFont(name: "SFPro-Bold", size: 23)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        nameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 154).isActive = true
        
        
    }
    func statusLabel() {
        let statusLabel = UILabel()
        view.addSubview(statusLabel)
        statusLabel.textColor = UIColor(named: "YPWhite")
        statusLabel.text = "Hello, world!"
        statusLabel.font = UIFont(name: "SFPro-Regular", size: 13)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 206).isActive = true
        statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        
    }
    func logOutButton() {
       let logOutButton = UIButton()
        view.addSubview(logOutButton)
        logOutButton.setImage(UIImage(systemName: "ipad.and.arrow.forward"), for: .normal)
        logOutButton.addTarget(self, action: #selector(logOutButtonTouch), for: .touchUpInside)
        logOutButton.translatesAutoresizingMaskIntoConstraints = false
        logOutButton.tintColor = UIColor(named: "YPRed")
        logOutButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        logOutButton.heightAnchor.constraint(equalToConstant: 22).isActive = true
        logOutButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        logOutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -26).isActive = true
        
        
    }
    
    @objc
    private func logOutButtonTouch(_ sender: Any) {
    
    }
    
    
    
    
}
