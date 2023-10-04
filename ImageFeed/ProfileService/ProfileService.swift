//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Andrey Nikolaev on 16.09.2023.
//

import Foundation
import WebKit

struct Profile {
    var userName: String?
    var name: String?
    var loginName: String?
    var bio: String?
}

final class ProfileService {
    
    
 static let shared = ProfileService()
    
    private let urlSession = URLSession.shared
    var fetchProfileOneWork = false
    private(set) var profile: Profile?
    
  
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
     assert(Thread.isMainThread)
        if fetchProfileOneWork {return}
        fetchProfileOneWork = true
        guard let token = OAuth2TokenStorage().token else {return}
        let request = selfProfileRequest()
        let task = object(for: request) {  result in
            switch result {
            case .success(let body):
                let userName = body.userName
                let firstName = body.firstName
                let lastName = body.lastName
                let bio = body.bio
                self.profile = Profile(userName: userName, name: "\(firstName)" + " " + "\(lastName)", loginName: "@\(userName)", bio: bio)
                completion(.success(self.profile!))
                
            case .failure(let error):

                print(error)
                completion(.failure(error))
            } }
        
        task.resume()
    }
    }

extension ProfileService {
    private func object(
        for request: URLRequest,
        completion: @escaping (Result<ProfileResult, Error>) -> Void
    ) -> URLSessionTask {
        return urlSession.objectTask(for: request) { (result: Result<ProfileResult, Error>) in
            let response = result
            completion(response)
        }
    }
    private func selfProfileRequest() -> URLRequest {
        URLRequest.makeHTTPRequestProfile(
            path: "/me",
            httpMethod: "GET",
            baseURL: URL(string: "https://api.unsplash.com")!
        ) }
    struct ProfileResult: Codable {
        
        let userName: String
        let firstName: String
        let lastName: String
        let bio: String
        
        enum CodingKeys: String, CodingKey {
            case userName = "username"
            case firstName = "first_name"
            case lastName = "last_name"
            case bio = "bio"
        }
    }
    
}

extension URLRequest {
    static func makeHTTPRequestProfile(
        path: String,
        httpMethod: String,
        baseURL: URL = DefaultBaseURL,
        token: String = OAuth2TokenStorage().token!
        
    ) -> URLRequest {
        var request = URLRequest(url: URL(string: path, relativeTo: baseURL)!)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = httpMethod
        return request
    }
}

enum NetworkErrorProfileService: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
}
