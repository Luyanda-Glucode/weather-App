import Foundation

struct WeatherResponse: Codable {
  var data: ResponseData?
}

struct ResponseData: Codable {
    var request: [RequestData]?
    var current_condition: [CurrentConditions]?
    var weather: [Weather]?
}

struct RequestData: Codable {
    var type: String?
    var query: String?
}

struct CurrentConditions: Codable {
    var observation_time: String?
    var temp_C: String?
    var temp_F: String?
    var weatherIconUrl: [WeatherUrl]?
    var weatherDesc: [WeatherDesc]?
}

struct Weather: Codable {
    var date: String?
    var hourly: [Hourly]?
}
struct Hourly: Codable {
    var time: String?
    var temp_C: String?
    var temp_F: String?
    var weatherIconUrl: [WeatherUrl]?
    var weatherDesc: [WeatherDesc]?
}
struct WeatherUrl: Codable {
    var value: String?
}

struct WeatherDesc: Codable {
    var value: String?
}
