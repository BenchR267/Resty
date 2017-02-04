//
//  Endpoint.swift
//  RestClient
//
//  Created by Benjamin Herzog on 04/02/2017.
//
//

import Foundation

public protocol HeaderType {
    var header: [String: String] { get }
}

public extension HeaderType {
    var header: [String: String] {
        return [:]
    }
}

public protocol URLParameterType {
    var urlParameter: [String: String] { get }
}

public extension URLParameterType {
    var urlParameter: [String: String] {
        return [:]
    }
}

public enum PostBody {
    case none, string(String), data(Data), json(Any), url([String: String])
}

public protocol PostBodyType {
    var postBody: PostBody { get }
}

public extension PostBodyType {
    var postBody: PostBody {
        return .none
    }
}

public protocol Endpoint: URLParameterType, HeaderType {
    associatedtype ResponseType: JSONObject
    
    var path: String { get }
}

public protocol GET: Endpoint {}
public protocol POST: Endpoint, PostBodyType {}
public protocol PUT: Endpoint, PostBodyType {}
public protocol DELETE: Endpoint, PostBodyType {}
