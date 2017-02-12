//
//  Authenticator.swift
//  Resty
//
//  Created by Benjamin Herzog on 04/02/2017.
//
//

import Foundation

public protocol Authenticator {
    func authenticate(request: inout URLRequest)
}

public struct SimpleAuthenticator: Authenticator {
    
    public let authenticationBlock: (inout URLRequest) -> Void
    
    public init(block: @escaping (inout URLRequest) -> Void) {
        self.authenticationBlock = block
    }
    
    public func authenticate(request: inout URLRequest) {
        self.authenticationBlock(&request)
    }
    
}
