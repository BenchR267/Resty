//
//  Response.swift
//  Resty
//
//  Created by Benjamin Herzog on 04/02/2017.
//
//

import Foundation

public struct Response<ResponseType: JSONObject> {
    public let res: ResponseType?
    public let error: Error?
}
