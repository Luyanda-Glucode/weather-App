//
//  Client.swift
//  weatherApp
//
//  Created by Luyanda Sikithi on 2022/11/04.
//

import Foundation
import Combine
struct Client {
    private let urlSession: URLSession
    private let environment: Environment
    
    init(urlSession: URLSession = .shared, environment: Environment = .development) {
        self.urlSession = urlSession
        self.environment = environment
    }
    
    func publisherForRequest<RequestType: Request>(_ request: RequestType) -> AnyPublisher<RequestType.response, Error> {
        let url = environment.baseUrl
        
        var urlRequest = URLRequest(url: url)
        urlRequest.url = URL(string: urlRequest.url?.absoluteString.removingPercentEncoding ?? "")
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.httpBody = request.body
        
        let publisher = urlSession.dataTaskPublisher(for: urlRequest).tryMap { data, response in
            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
                throw APIError.requestFailed(statusCode)
            }
            return data
        }
        .tryMap { responseData -> RequestType.response in
            try request.handle(response: responseData)
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
        
        return publisher
    }
}
