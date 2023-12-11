//
//  CurrentWeatherResponse.swift
//  WeatherAppSwiftUI
//
//  Created by Evgeny on 8.12.23.
//

import Foundation

// MARK: - CurrentWeatherResponse
struct WeatherResponse: Codable {
    let weather: [Weather]?
    let list: [List]?
    let main: Main?
    let dt: Int?
}
