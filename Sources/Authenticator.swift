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
    
    let authenticationBlock: (inout URLRequest) -> Void
    
    public func authenticate(request: inout URLRequest) {
        self.authenticationBlock(&request)
    }
    
}
