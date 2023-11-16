//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Andrey Nikolaev on 22.10.2023.
//

import Foundation

/*
struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}

struct UrlsResult: Decodable {
    let thumb: String
    let full: String
    
}
*/
 
final class ImagesListService {
    
    private let urlSession = URLSession.shared
    
    static let DidChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private (set) var photos: [Photo] = []
    
    private var  lastLoadedPage: Int?
    
    private let perPage = 10
    
    var fetchProfileImageOneWork: Bool = false
    
    
    func fetchPhotosNextPage(_ token: String, _ completion: @escaping (Result<[Photo], Error>) -> Void) {
        
        let nextPage = lastLoadedPage == nil
           ? 1
           : lastLoadedPage! + 1
        
        assert(Thread.isMainThread)
        if OAuth2TokenStorage().token == nil {return}
        if fetchProfileImageOneWork {return}
        fetchProfileImageOneWork = true
        guard let token = OAuth2TokenStorage().token else {return}
        let request = imagesListURLRequest(page: nextPage, perPage: self.perPage)
        let task = object(for: request) {  result in
            switch result {
            case .success(let body):
                guard let  result = body else {return}
                self.photos = self.photos + result
                print(self.photos)
                completion(.success(self.photos))
                NotificationCenter.default
                    .post(
                        name: ProfileImageService.DidChangeNotification,
                        object: self,
                        userInfo: ["URL" : [Photo]()])
                
            case .failure(let error):
                
                print(error)
                completion(.failure(error))
            } }
        
        task.resume()
    }
}

extension ImagesListService {
    private func object(
        for request: URLRequest,
        completion: @escaping (Result<[Photo]?, Error>) -> Void
    ) -> URLSessionTask {
        return urlSession.objectTask(for: request) { (result: Result<[Photo]?, Error>) in
            let response = result
            completion(response)
        }
    }
    
    
    private func imagesListURLRequest(page: Int, perPage: Int) -> URLRequest {
        URLRequest.makeHTTPRequestImagesListURL(
            path: "/photos?page=\(page)",
            httpMethod: "GET",
            baseURL: URL(string: "https://api.unsplash.com")!
        ) }
    }


struct Photo: Codable {
    
    let id: String
    let size: CGSize
    let width: Int
    let lenth: Int
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: Photos?
    let largeImageURL: Photos?
    let isLiked: Bool
       

       enum CodingKeys: String, CodingKey {
           case id
           case createdAt = "created_at"
           case size
           case width
           case lenth
           case isLiked = "liked_by_user"
           case welcomeDescription = "description"
           case thumbImageURL
           case largeImageURL
       }
}

struct Photos: Codable {
    let large: String
    let thumb: String
}


extension URLRequest {
static func makeHTTPRequestImagesListURL(
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

