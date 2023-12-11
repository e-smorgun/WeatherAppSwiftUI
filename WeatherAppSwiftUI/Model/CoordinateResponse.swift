//
//  CoordinateResponse.swift
//  WeatherAppSwiftUI
//
//  Created by Evgeny on 11.12.23.
//

import Foundation

// MARK: - CoordinateResponse
struct CoordinateResponse: Codable {
    let location: Location?
}

// MARK: - Location
struct Location: Codable {
    let name, lat, lon: String?

    enum CodingKeys: String, CodingKey {
        case name, lat, lon
    }
}
