//
//  DailyWeatherData.swift
//  WeatherAppSwiftUI
//
//  Created by Evgeny on 9.12.23.
//

import Foundation

class DailyWeatherData: Codable {
    let date, imageID: String
    let minTemp, maxTemp: Double
 
    init(date: String, imageID: String, minTemp: Double, maxTemp: Double) {
        self.date = date
        self.imageID = imageID
        self.minTemp = minTemp
        self.maxTemp = maxTemp
    }
}
