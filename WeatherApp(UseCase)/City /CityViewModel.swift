//
//  CityViewModel.swift
//  WeatherApp(UseCase)
//
//  Created by MT on 3/28/22.
//

import Foundation

final class CityViewModel {
    var reloadImageData: ((Data) -> Void)?
    var reloadData: ((ViewData) -> Void)?

    let city: String
    private let session: URLSession = .shared
    private let userDefaults: UserDefaults = .standard

    init(city: String) {
        self.city = city
    }

    func fetchWeather() {
        makeFetchWeatherRequest(with: city)
    }
}

extension CityViewModel {
    struct ViewData {
        let humidity: String
        let description: String
        let temperature: String
    }
}

private extension CityViewModel {
    func makeUrl(with city: String) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.worldweatheronline.com"
        components.path = "/premium/v1/weather.ashx"
        components.queryItems = [
            .init(name: "q", value: city),
            .init(name: "format", value: "json"),
            .init(name: "key", value: "0c3821cc308b46fb8a594405221403")
        ]
        return components.url
    }

    func makeUrlRequest(from url: URL) -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        urlRequest.timeoutInterval = 20
        urlRequest.httpMethod = "get"
        return urlRequest
    }

    func makeFetchWeatherRequest(with city: String) {
        guard let url = makeUrl(with: city) else { return }
        let urlRequest = makeUrlRequest(from: url)
        let task = session.dataTask(with: urlRequest) { [weak self] data, _, _ in
            guard let self = self, let data = data else { return }
            let decoder = JSONDecoder()
            do {
                let weatherData = try decoder.decode(WeatherData.self, from: data)
                guard let currentCondition = weatherData.data.currentCondition.first else { return }
                self.reloadViewData(with: currentCondition)
                self.downloadImageData(with: currentCondition)
            } catch {
                print("error: ", error)
            }
        }
        task.resume()
    }

    func reloadViewData(with currentCondition: WeatherData.CurrentCondition) {
        let humidity = currentCondition.humidityString
        let description = currentCondition.descriptionString ?? ""
        let temperature = currentCondition.temperatureString
        let viewData = ViewData(humidity: humidity, description: description, temperature: temperature)
        self.reloadData?(viewData)
    }

    func downloadImageData(with currentCondition: WeatherData.CurrentCondition) {
        guard let iconUrl = currentCondition.iconUrl else { return }
        let task = session.dataTask(with: iconUrl) { [weak self] data, _, _ in
            guard let self = self, let data = data else { return }
            self.reloadImageData?(data)
        }
        task.resume()
    }
}

private extension WeatherData.CurrentCondition {
    var iconUrl: URL? {
        guard let stringUrl = weatherIconUrl.first?.value else { return nil }
        return URL(string: stringUrl)
    }

    var humidityString: String {
        return "Humidity: \(humidity)%"
    }

    var descriptionString: String? {
        guard let description = description.first?.value else { return nil }
        return "Description: \(description)"
    }

    var temperatureString: String {
        return "Temperature: \(temperature)\u{00B0}C"
    }
}
