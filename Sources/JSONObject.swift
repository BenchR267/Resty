//
//  JSONObject.swift
//  Resty
//
//  Created by Benjamin Herzog on 04/02/2017.
//
//

import Foundation

public protocol JSONObject {
    init?(json: Any)
}

/*
Unfortunately this is not possible:
 
extension Array: JSONObject where Element: JSONObject {
    init?(json: Any) {
        guard let e = json as? [Any] else {
            return nil
        }
        self = e.flatMap(Element.init)
    }
}
 */

public struct JSONArray<Element: JSONObject>: JSONObject {
    
    public let array: [Element]
    
    public init?(json: Any) {
        guard let e = json as? [Any] else {
            return nil
        }
        self.array = e.flatMap(Element.init)
    }
    
}
