//
//  CoordinateFounder.swift
//  WeatherAppSwiftUI
//
//  Created by Evgeny on 11.12.23.
//

import Foundation

class CoordinateFounder {
    private let dataService = DataService()
    private let APIKey: String = "6fb96aa2ec992a42a476b7c47e6aa815"
    
    func fetchCoordinate(place: String, completion: @escaping (Result<CoordinateResponse, Error>) -> Void) {
        
        let url = URL(string: "http://api.weatherstack.com/current?access_key=\(APIKey)&query=\(place)")!
        print(url)
        
        self.dataService.fetchModel(from: url) { (result: Result<CoordinateResponse, Error>) in
            switch result {
            case .success(let response):
                do {
                    let encoder = JSONEncoder()
                    let data = try encoder.encode(response)
                } catch {
                    print("Error encoding data:", error)
                }
                completion(.success(response))
            case .failure(let error):
                ("Network error:", error)
                completion(.failure(error))
            }
        }
    }
}
