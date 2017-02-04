//
//  Response.swift
//  RestClient
//
//  Created by Benjamin Herzog on 04/02/2017.
//
//

import Foundation

public struct Response<ResponseType: JSONObject> {
    let res: ResponseType?
    let error: Error?
}
