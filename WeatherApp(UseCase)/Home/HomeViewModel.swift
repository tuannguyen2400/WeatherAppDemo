//
//  HomeViewModel.swift
//  WeatherApp(UseCase)
//
//  Created by MT on 3/28/22.
//

import Foundation

final class HomeViewModel {
    private let queue = DispatchQueue.main
    private var searchTask: DispatchWorkItem?
    private var isSearching = false
    private var searchedCities = [String]()
    private var viewedCities = [String]()

    var cities: [String] {
        return isSearching ? searchedCities : viewedCities
    }

    var reloadData: (() -> Void)?

    private let session: URLSession = .shared
    private let userDefaults: UserDefaults = .standard

    func reloadViewedCities() {
        viewedCities = UserDefaults.standard.stringArray(forKey: "viewedCities") ?? []
        reloadData?()
    }

    func beginSearching() {
        isSearching = true
        reloadData?()
    }

    func endSearching() {
        isSearching = false
        searchedCities.removeAll()
        reloadData?()
    }

    func didSelectCity(at index: Int) -> String {
        let city = cities[index]
        saveCity(city)
        return city
    }

    func search(with text: String) {
        searchTask?.cancel()
        searchTask = nil
        guard text.count >= 3 else {
            searchedCities.removeAll()
            reloadData?()
            return
        }
        let searchTask = DispatchWorkItem(block: { [weak self] in
            self?.makeSearchRequest(with: text)
            self?.searchTask = nil
        })
        self.searchTask = searchTask
        queue.asyncAfter(deadline: .now() + 0.5, execute: searchTask)
    }
}

private extension HomeViewModel {
    func makeUrl(with query: String) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.worldweatheronline.com"
        components.path = "/premium/v1/search.ashx"
        components.queryItems = [
            .init(name: "q", value: query),
            .init(name: "num_of_results", value: "10"),
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

    func makeSearchRequest(with query: String) {
        guard let url = makeUrl(with: query) else { return }
        let urlRequest = makeUrlRequest(from: url)
        let task = session.dataTask(with: urlRequest) { [weak self] data, _, _ in
            guard let self = self, let data = data else { return }
            let decoder = JSONDecoder()
            do {
                let searchData = try decoder.decode(Search.self, from: data)
                self.searchedCities = searchData.data.cities
            } catch {
                self.searchedCities.removeAll()
                print("error: ", error)
            }
            self.reloadData?()
        }
        task.resume()
    }

    func saveCity(_ city: String) {
        var viewedCity = userDefaults.stringArray(forKey: "viewedCities") ?? []
        if let removeIndex = viewedCity.firstIndex(where: { $0 == city }) {
            viewedCity.remove(at: removeIndex)
        }
        viewedCity.insert(city, at: 0)
        if viewedCity.count > 10 {
            viewedCity.removeLast()
        }
        userDefaults.set(viewedCity, forKey: "viewedCities")
    }
}

private extension Search.Data {
    var cities: [String] {
        return result.compactMap { r in
            guard let areaName = r.areaName.first?.value else { return nil }
            var city = areaName
            if let country = r.country.first?.value, !country.isEmpty {
                city += ", \(country)"
            }
            if let region = r.region.first?.value, !region.isEmpty {
                city += ", \(region)"
            }
            return city
        }
    }
}
