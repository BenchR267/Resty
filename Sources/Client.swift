//
//  Client.swift
//  Resty
//
//  Created by Benjamin Herzog on 04/02/2017.
//
//

import Foundation

public class Client {
    
    // MARK: - Errors
    
    public enum Errors: Error {
        case invalidUrl(String)
        case invalidResponse(Data?, Error?)
        case requestFailed(Int, Error?)
    }
    
    // MARK: - Properties
    
    private let session = URLSession(configuration: URLSessionConfiguration.default)
    
    public var baseUrl: URL
    public let timeout: TimeInterval
    private let authenticator: Authenticator
    
    // MARK: - API
    
    public init(baseUrl: String, authenticator: Authenticator, timeout: TimeInterval = 10) {
        
        guard let url = URL(string: baseUrl) else {
            fatalError("\(baseUrl) is not a valid URL. Aborting!")
        }
        
        self.baseUrl = url
        self.authenticator = authenticator
        self.timeout = timeout
    }
    
    public typealias Completion<R: JSONObject> = (Response<R>) -> Void
    
    public func get<E: GET>(_ endpoint: E, completion: @escaping Completion<E.ResponseType>) {
        self.start(endpoint: endpoint, method: .get, completion: completion)
    }
    
    public func post<E: POST>(_ endpoint: E, completion: @escaping Completion<E.ResponseType>) {
        self.start(endpoint: endpoint, method: .post, completion: completion)
    }
    
    public func put<E: PUT>(_ endpoint: E, completion: @escaping Completion<E.ResponseType>) {
        self.start(endpoint: endpoint, method: .put, completion: completion)
    }
    
    public func delete<E: DELETE>(_ endpoint: E, completion: @escaping Completion<E.ResponseType>) {
        self.start(endpoint: endpoint, method: .delete, completion: completion)
    }
    
    // MARK: - Private
    
    private func start<E: Endpoint>(endpoint: E, method: RequestMethod, completion: @escaping Completion<E.ResponseType>) {
        
        guard let url = URL(string: endpoint.path, relativeTo: self.baseUrl) else {
            completion(Response(res: nil, error: Errors.invalidUrl(endpoint.path)))
            return
        }
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            completion(Response(res: nil, error: Errors.invalidUrl(url.absoluteString)))
            return
        }
        
        // URL Parameter
        if !endpoint.urlParameter.isEmpty {
            components.query = URLParameterEncoder.encode(from: endpoint.urlParameter)
        }
        
        guard let requestUrl = components.url else {
            completion(Response(res: nil, error: Errors.invalidUrl(url.absoluteString)))
            return
        }
        
        var request = URLRequest(url: requestUrl)
        request.httpMethod = method.rawValue
        
        // HEADER
        endpoint.header.forEach { k, v in
            request.setValue(v, forHTTPHeaderField: k)
        }
        
        // POST BODY
        if let post = endpoint as? PostBodyType, let data = PostParameterEncoder.encode(from: post.postBody) {
            request.setValue("\(data.count)", forHTTPHeaderField: "Content-Length")
            request.httpBody = data
        }
        
        // Authentication
        self.authenticator.authenticate(request: &request)
        
        let task = self.session.dataTask(with: request) { data, response, error in
            
            if let error = error {
                let res = response as? HTTPURLResponse
                completion(Response(res: nil, error: Errors.requestFailed(res?.statusCode ?? -1, error)))
                return
            }
            
            guard let data = data else {
                completion(Response(res: nil, error: Errors.invalidResponse(nil, error)))
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                let obj = E.ResponseType(json: json)
                completion(Response(res: obj, error: nil))
            } catch {
                completion(Response(res: nil, error: error))
            }
            
        }
        task.resume()
    }
    
}
