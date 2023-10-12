//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Andrey Nikolaev on 22.09.2023.
//

import Foundation



final class ProfileImageService {
    
    static let DidChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    static let shared = ProfileImageService()
    private var profileService = ProfileService.shared
    private let urlSession = URLSession.shared
    var fetchProfileImageOneWork = false
    private (set) var avatarURl: String?
    var userName = ""
    var imageURLPath = ""
    
    
    func fetchProfileImageURL(userName: String, _ completion: @escaping (Result<String?, Error>) -> Void) {
        assert(Thread.isMainThread)
        if OAuth2TokenStorage().token == nil {return}
        if fetchProfileImageOneWork {return}
        fetchProfileImageOneWork = true
        guard let userName = profileService.profile?.userName else {return}
        self.userName = userName
        let request = profileImageURLRequest(username: self.userName)
        let task = object(for: request) {  result in
            switch result {
            case .success(let body):
                guard let profileImage = body.profileImage else {return}
                self.avatarURl = profileImage.small
                completion(.success(self.avatarURl))
                NotificationCenter.default
                    .post(
                        name: ProfileImageService.DidChangeNotification,
                        object: self,
                        userInfo: ["URL" : profileImage])
                
            case .failure(let error):
                
                print(error)
                completion(.failure(error))
            } }
        
        task.resume()
    }
}

extension ProfileImageService {
    private func object(
        for request: URLRequest,
        completion: @escaping (Result<UserResult, Error>) -> Void
    ) -> URLSessionTask {
        return urlSession.objectTask(for: request) { (result: Result<UserResult, Error>) in
            let response = result
            completion(response)
        }
    }
    
    
    private func profileImageURLRequest(username: String) -> URLRequest {
        URLRequest.makeHTTPRequestProfileImageURL(
            path: "/users/\(username)",
            httpMethod: "GET",
            baseURL: URL(string: "https://api.unsplash.com")!
        ) }
    struct UserResult: Codable {
        let profileImage: ImageURL?
        
        enum CodingKeys: String, CodingKey {
            case profileImage = "profile_image"
        }
    }
    
    struct ImageURL: Codable {
        let small: String
    }
    
}




extension URLRequest {
    static func makeHTTPRequestProfileImageURL(
        path: String,
        httpMethod: String,
        baseURL: URL = DefaultBaseURL,
        token: String = OAuth2TokenStorage().token ?? ""
        
    ) -> URLRequest {
        print(path)
        var request = URLRequest(url: URL(string: path, relativeTo: baseURL)!)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = httpMethod
        return request
    }
}


