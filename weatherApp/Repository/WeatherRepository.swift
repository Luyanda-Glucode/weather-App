//
//  WeatherRepository.swift
//  weatherApp
//
//  Created by Luyanda Sikithi on 2022/11/04.
//

import Foundation
import Combine
import Resolver
protocol WeatherRepositoryProtocol {
    func getWeather(completionState: @escaping ((Subscribers.Completion<Error>) -> Void),
                    recievedValue: @escaping ((WeatherResponse) -> Void))
}

final class WeatherRepository: WeatherRepositoryProtocol {
    
    private var subscriptions: Set<AnyCancellable> = []
    @Injected var client: Client
    
    func getWeather(completionState: @escaping ((Subscribers.Completion<Error>) -> Void), recievedValue: @escaping ((WeatherResponse) -> Void)) {
        let request = WeatherRequest()
        client.publisherForRequest(request)
            .sink { resuls in
                completionState(resuls)
            } receiveValue: { response in
                recievedValue(response)
            }.store(in: &subscriptions)
    }
}
