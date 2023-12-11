//
//  DescriptionWeather.swift
//  WeatherAppSwiftUI
//
//  Created by Evgeny on 8.12.23.
//

import Foundation

// MARK: - List
struct List: Codable {
    let main: Main
    let weather: [Weather]
    var dtTxt: String

    enum CodingKeys: String, CodingKey {
        case main, weather
        case dtTxt = "dt_txt"
    }
}

// MARK: - Main
struct Main: Codable {
    let temp, feelsLike, tempMin, tempMax: Double

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
}

// MARK: - Weather
struct Weather: Codable {
    let main, description, icon: String
}
