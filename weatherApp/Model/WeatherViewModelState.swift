import Foundation
enum WeatherViewModelState {
    case idle
    case loading
    case loaded
    case error(Error)
}

