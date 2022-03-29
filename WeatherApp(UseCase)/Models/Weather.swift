//
//  Weather.swift
//  WeatherApp(UseCase)
//
//  Created by MT on 3/28/22.
//

struct WeatherData: Decodable, Equatable {
    let data: Data
}

extension WeatherData {
    struct Data: Decodable, Equatable {
        let currentCondition: [CurrentCondition]

        enum CodingKeys: String, CodingKey {
            case currentCondition = "current_condition"
        }
    }
}

extension WeatherData {
    struct CurrentCondition: Decodable, Equatable {
        let weatherIconUrl: [Value]
        let humidity: String
        let description: [Value]
        let temperature: String

        enum CodingKeys: String, CodingKey {
            case weatherIconUrl
            case humidity
            case description = "weatherDesc"
            case temperature = "temp_C"
        }
    }
}

