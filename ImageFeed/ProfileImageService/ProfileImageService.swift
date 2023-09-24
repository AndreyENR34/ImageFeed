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
  
  
    
    func fetchProfileImageURL(userName: String, _ completion: @escaping (Result<String?, Error>) -> Void) {
     assert(Thread.isMainThread)
        if fetchProfileImageOneWork {return}
        fetchProfileImageOneWork = true
        guard let token = OAuth2TokenStorage().token else {return}
        guard let userName = profileService.profile?.userName else {return}
            self.userName = userName
        let request = profileImageURLRequest(username: self.userName)
        let task = object(for: request) {  result in
            switch result {
            case .success(let body):
                guard let profileImage = body.profileImage else {return}
                self.avatarURl = profileImage.small
                print(self.avatarURl)
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
        let decoder = JSONDecoder()
        return urlSession.dataProfileImage(for: request) { (result: Result<Data, Error>) in
            let response = result.flatMap { data -> Result<UserResult, Error> in
                Result { try decoder.decode(UserResult.self, from: data) }
            }
           print(response)
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
        token: String = OAuth2TokenStorage().token!
        
    ) -> URLRequest {
        print(path)
        var request = URLRequest(url: URL(string: path, relativeTo: baseURL)!)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = httpMethod
        print(request)
        return request
    }
}

enum NetworkErrorProfileImageService: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
}
extension URLSession {
    func dataProfileImage(
        for request: URLRequest,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionTask {
        let fulfillCompletion: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        let task = dataTask(with: request, completionHandler: { data, response, error in
            if let data = data,
               let response = response,
               let statusCode = (response as? HTTPURLResponse)?.statusCode
            {   print(statusCode)
                print(String(data: data, encoding: .utf8))
                print(response)
                if 200 ..< 300 ~= statusCode {
                    print(statusCode)
                    fulfillCompletion(.success(data))
                    
                } else {
                    fulfillCompletion(.failure(NetworkErrorProfileImageService.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                fulfillCompletion(.failure(NetworkErrorProfileImageService.urlRequestError(error)))
            } else {
                fulfillCompletion(.failure(NetworkErrorProfileImageService.urlSessionError))
            }
        })
        task.resume()
        return task
    }
}
