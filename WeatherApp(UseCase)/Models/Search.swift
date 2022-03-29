//
//  Search.swift
//  WeatherApp(UseCase)
//
//  Created by MT on 3/28/22.
//

struct Search: Decodable, Equatable {
    let data: Data

    enum CodingKeys: String, CodingKey {
        case data = "search_api"
    }
}

extension Search {
    struct Data: Decodable, Equatable {
        let result: [Result]
    }
}

extension Search {
    struct Result: Decodable, Equatable {
        let areaName: [Value]
        let country: [Value]
        let region: [Value]
    }
}
