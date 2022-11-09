import Foundation
import Combine

protocol WeatherRepositoryProtocol {
   typealias completion = ((Subscribers.Completion<Error>) -> Void)
    func getWeather(completionState: @escaping completion,
                    recievedValue: @escaping ((WeatherResponse) -> Void))
}

final class WeatherRepository: WeatherRepositoryProtocol {
    
    private var subscriptions: Set<AnyCancellable> = []
    var client = Client()
    
    func getWeather(completionState: @escaping completion, recievedValue: @escaping ((WeatherResponse) -> Void)) {
        let request = WeatherRequest()
        client.publisherForRequest(request)
            .sink { resuls in
                completionState(resuls)
            } receiveValue: { response in
                recievedValue(response)
            }.store(in: &subscriptions)
    }
}
