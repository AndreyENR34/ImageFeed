//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Andrey Nikolaev on 14.04.2023.
//

import Foundation

struct OAuthTokenResponseBody: Decodable {
    let accessToken: String
    let tokenType: String
    let scope: String
    let createdAt: Int
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case scope = "scope"
        case createdAt = "created_at"
    }
}

final class OAuth2Service {
    
    var lastCode: String?
    var fetchOneWork = false
    static let shared = OAuth2Service()
    private var task: URLSessionTask?
    private let urlSession = URLSession.shared
    private (set) var authToken: String? {
        get {
            return OAuth2TokenStorage().token
        }
        set {
            OAuth2TokenStorage().token = newValue
        }
    }
    
    func fetchAuthToken(
        _ code: String,
        completion: @escaping (Result<String, Error>) -> Void ){
            assert(Thread.isMainThread)
            if lastCode == code  {return}
            task?.cancel()
            lastCode = code
            let request = authTokenRequest(code: code)
            let task = object(for: request) { [weak self] result in
                switch result {
                case .success(let body):
                    self?.task = nil
                    let authToken = body.accessToken
                    OAuth2TokenStorage().token = authToken
                    print(authToken)
                    self?.authToken = authToken
                    completion(.success(authToken))
                case .failure(let error):
                    self?.lastCode = nil
                    completion(.failure(error))
                }
            }
            self.task = task
            task.resume()
        }
}

extension OAuth2Service {
    private func object(
        for request: URLRequest,
        completion: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void
    ) -> URLSessionTask {
        return urlSession.objectTask(for: request) { (result: Result<OAuthTokenResponseBody, Error>) in
            let response = result
            completion(response)
        }
    }
    private func authTokenRequest(code: String) -> URLRequest {
        URLRequest.makeHTTPRequest(
            path: "/oauth/token"
            + "?client_id=\(AccessKey)"
            + "&&client_secret=\(SecretKey)"
            + "&&redirect_uri=\(RedirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            httpMethod: "POST",
            baseURL: URL(string: "https://unsplash.com")!
        ) }
}

extension URLRequest {
    static func makeHTTPRequest(
        path: String,
        httpMethod: String,
        baseURL: URL = DefaultBaseURL
    ) -> URLRequest {
        var request = URLRequest(url: URL(string: path, relativeTo: baseURL)!)
        request.httpMethod = httpMethod
        return request
    }
    
}

// MARK: - Network Connection
enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    case makeGenericError
}

public extension URLSession {
    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        let fulfillCompletion: (Result<T, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        let task = dataTask(with: request, completionHandler: { data, response, error in
            if let data = data,
               let response = response,
               let statusCode = (response as? HTTPURLResponse)?.statusCode
            {
                if 200 ..< 300 ~= statusCode {
                    do{
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(T.self,from: data)
                        fulfillCompletion(.success(result))
                    } catch {fulfillCompletion(.failure(error))
                    }
                } else {
                    fulfillCompletion(.failure(NetworkError.makeGenericError))
                }
            } else if let error = error {
                fulfillCompletion(.failure(error))
                
            } else {
                fulfillCompletion(.failure(NetworkError.urlSessionError))
            }
            
        })
        return task
    }
    
}


