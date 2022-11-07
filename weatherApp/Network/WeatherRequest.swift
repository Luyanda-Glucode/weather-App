//
//  WeatherRequest.swift
//  weatherApp
//
//  Created by Luyanda Sikithi on 2022/11/04.
//

import Foundation
typealias Response = WeatherResponse

struct WeatherRequest: Request {
   
    var method: HTTPMethod { .GET }
    var additionalHeaders: [String : String] { [:] }
    var body: Data? { nil }
    var parameters: [String:String]? { nil}
    
    func handle(response: Data) throws -> Response {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(Response.self, from: response)
    }
}
