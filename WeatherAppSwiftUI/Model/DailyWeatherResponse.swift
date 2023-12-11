//
//  WeatherResponse.swift
//  WeatherAppSwiftUI
//
//  Created by Evgeny on 7.12.23.
//

import Foundation

// MARK: - WeatherResponse
struct DailyWeatherResponse: Codable {
    let cod: String
    let message, cnt: Int
}
