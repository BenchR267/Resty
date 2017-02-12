//
//  ParameterDecoder.swift
//  Resty
//
//  Created by Benjamin Herzog on 04/02/2017.
//
//

import Foundation

public protocol ParameterEncoder {
    associatedtype From
    associatedtype To
    static func encode(from: From) -> To
}

public struct URLParameterEncoder: ParameterEncoder {
    public static func encode(from: [String: String]) -> String {
        return from.map { k, v in "\(k)=\(v)" }
                   .joined(separator: "&")
    }
}

public struct PostParameterEncoder: ParameterEncoder {
    public static func encode(from: PostBody) -> Data? {
        
        switch from {
        case .none: return nil
        case .string(let string): return string.data(using: .utf8)
        case .data(let data): return data
        case .json(let json):
            do {
                return try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            } catch {
                print("Could not serialize object: \(json)")
                return nil
            }
        case .url(let p): return URLParameterEncoder.encode(from: p).data(using: .utf8)
        }
    }
}
