import Foundation

enum APIError: Error {
    case requestFailed(Int)
    case noWeatherResponse
}

extension APIError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .requestFailed(_):
            return  Constants.failedRequest
        case .noWeatherResponse:
            return Constants.noWeatherResponse
        }
    }
}
