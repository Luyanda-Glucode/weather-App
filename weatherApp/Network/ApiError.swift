//
//  ApiError.swift
//  weatherApp
//
//  Created by Luyanda Sikithi on 2022/11/04.
//

import Foundation

enum APIError: Error {
    case requestFailed(Int)
    case noMoviesFound
}

extension APIError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .requestFailed(_):
            return  Constants.failedRequest
        case .noMoviesFound:
            return Constants.noWeatherResponse
        }
    }
}
