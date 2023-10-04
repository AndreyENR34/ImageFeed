//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Andrey Nikolaev on 11.03.2023.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    
    private let profileservice = ProfileService.shared
    private let profileimageservice = ProfileImageService.shared
    
    var profileImage = UIImage(named: "profileImage")
    
    let emailLabel = UILabel()
    var email = "@ekaterina_nov"
    
    let nameLabel = UILabel()
    var name = "Екатерина Новикова"
    
    let statusLabel = UILabel()
    var status = "Hello, world!"
    
    let logOutButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showPhotoView()
        showEmailLabel()
        showNameLabel()
        showStatusLabel()
        showlogOutButton()
        updateProfileDetails()
    }
    
    private func updateProfileDetails() {
        emailLabel.text = profileservice.profile?.loginName
        nameLabel.text = profileservice.profile?.name
        statusLabel.text = profileservice.profile?.bio
        guard let avatarURL = profileimageservice.avatarURl else {
            return}
        let imageUrlPath = URL(string: avatarURL)
        let profilePhotoView = UIImageView()
        
        profilePhotoView.kf.setImage(with: imageUrlPath)
        view.addSubview(profilePhotoView)
        profilePhotoView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profilePhotoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            profilePhotoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profilePhotoView.heightAnchor.constraint(equalToConstant: 70),
            profilePhotoView.widthAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    private func showPhotoView() {
        let profilePhotoView = UIImageView(image: profileImage)
        view.addSubview(profilePhotoView)
        profilePhotoView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profilePhotoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            profilePhotoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profilePhotoView.heightAnchor.constraint(equalToConstant: 70),
            profilePhotoView.widthAnchor.constraint(equalToConstant: 70)
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
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 110),
            nameLabel.heightAnchor.constraint(equalToConstant: 18),
            nameLabel.widthAnchor.constraint(equalToConstant: 235)
        ])
    }
    
    private func showEmailLabel() {
        view.addSubview(emailLabel)
        emailLabel.textColor = UIColor(named: "YPGrey")
        emailLabel.text = email
        emailLabel.font = UIFont(name: "SFPro-Regular", size: 13)
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emailLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 136),
            emailLabel.heightAnchor.constraint(equalToConstant: 18),
            emailLabel.widthAnchor.constraint(equalToConstant: 99)
        ])
    }
    
    private func showStatusLabel() {
        view.addSubview(statusLabel)
        statusLabel.textColor = UIColor(named: "YPWhite")
        statusLabel.text = status
        statusLabel.font = UIFont(name: "SFPro-Regular", size: 13)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            statusLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 162),
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            statusLabel.heightAnchor.constraint(equalToConstant: 18),
            statusLabel.widthAnchor.constraint(equalToConstant: 77)
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
            logOutButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 56),
            logOutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -26)
        ])
    }
    
    @objc
    private func logOutButtonTouch(_ sender: Any) {
        
    }
    
}
