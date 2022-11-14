//
//  Request.swift
//  weatherApp
//
//  Created by Luyanda Sikithi on 2022/11/04.
//

import Foundation
@frozen enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
}

protocol Request {
    associatedtype response
    var method: HTTPMethod { get }
    var body: Data? { get }
    
    func handle(response: Data) throws -> response
}
