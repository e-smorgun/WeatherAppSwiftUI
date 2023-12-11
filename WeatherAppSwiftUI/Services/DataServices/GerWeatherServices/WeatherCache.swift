//
//  WeatherCache.swift
//  WeatherAppSwiftUI
//
//  Created by Evgeny on 10.12.23.
//

import Foundation

class WeatherCache {
    static let shared = WeatherCache()
    private var cache = [String: WeatherResponse]()

    func getWeather(for key: String) -> WeatherResponse? {
        return cache[key]
    }

    func setWeather(_ weather: WeatherResponse, for key: String) {
        cache[key] = weather
    }
}
