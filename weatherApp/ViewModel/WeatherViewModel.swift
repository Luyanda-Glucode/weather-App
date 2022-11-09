import Foundation
import Combine
class WeatherViewModel {
    
    private let client = Client()
    var weather: WeatherResponse?
    var repository = WeatherRepository()
    @Published var state = WeatherViewModelState.idle
    
    func getWeather(){
        repository.getWeather(completionState: { results in
            switch results {
            case .finished: self.state = .loaded
            case.failure(let error):self.state = .error(error)
            }
        }, recievedValue: { [self] response in
            dump(response.data)
            weather = response
        })
    }
}
