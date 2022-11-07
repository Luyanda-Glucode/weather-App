//
//  WeatherViewModel.swift
//  weatherApp
//
//  Created by Luyanda Sikithi on 2022/11/04.
//

import Foundation
import Resolver
class WeatherViewModel {
    
    private let client = Client()
    private var weather: WeatherResponse?
    @Injected var repository: WeatherRepository
    
    func getWeather(){
        repository.getWeather(completionState: { results in
            switch results {
            case .finished: print("finfished")
            case.failure(let error): print("show error \(error.localizedDescription)")
            }
        }, recievedValue: { [self] response in
            weather = response
        })
    }
}
