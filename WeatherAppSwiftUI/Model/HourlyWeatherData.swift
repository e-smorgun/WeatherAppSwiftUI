//
//  FutureWeather.swift
//  WeatherAppSwiftUI
//
//  Created by Evgeny on 9.12.23.
//

import Foundation

class HourlyWeatherData: Codable {
    let date, imageID: String
    let weatherCondition: Double
    
    init(date: String, imageID: String, weatherCondition: Double) {
        self.date = date
        self.imageID = imageID
        self.weatherCondition = weatherCondition
    }
}
