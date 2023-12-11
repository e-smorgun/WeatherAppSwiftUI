//
//  CurrentWeatherService.swift
//  WeatherAppSwiftUI
//
//  Created by Evgeny on 8.12.23.
//

import Foundation

class CurrentWeatherService {
    private let locationManager = LocationManager()
    private let cacheManager = CacheManager()
    private let dataService = DataService()
    private let APIKey: String = "8d295f59a991836cce7b4e1723292375"
    private let cachePath: URL = {
        let documentsDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent("currentWeatherCache")
    }()
    
    func fetchWeatherByCoordinates(lat: String, lon: String, completion: @escaping (Result<WeatherResponse, Error>) -> Void) {
        if Reachability.isConnectedToNetwork() {
                   let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(self.APIKey)")!
                   print(url)
                   
                   self.dataService.fetchModel(from: url) { (result: Result<WeatherResponse, Error>) in
                       switch result {
                       case .success(let weatherResponse):
                           do {
                               let encoder = JSONEncoder()
                               let data = try encoder.encode(weatherResponse)
                               self.cacheManager.saveToCache(cachePath: self.cachePath, data: data)
                           } catch {
                               print("Error encoding data:", error)
                           }
                           
                           completion(.success(weatherResponse))
                           
                       case .failure(let error):
                           print("Network error:", error)
                           completion(.failure(error))
                       }
                   }
        } else {
            print("data from cach: ")
            if let cachedData = cacheManager.loadFromCache(cachePath: cachePath) {
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(WeatherResponse.self, from: cachedData)
                    print("success:", result)
                    completion(.success(result))
                } catch {
                    print("Error:", error)
                    completion(.failure(error))
                }
            } else {
                completion(.failure(NSError(domain: "No internet connection and no cached data", code: 0, userInfo: nil)))
            }
        }
    }
    
    func fetchCurrentLocationWeather(completion: @escaping (Result<WeatherResponse, Error>) -> Void) {
        if Reachability.isConnectedToNetwork() {
               if let currentLocation = locationManager.currentLocation {
                   let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(currentLocation.coordinate.latitude)&lon=\(currentLocation.coordinate.longitude)&appid=\(self.APIKey)")!
                   print(url)
                   
                   self.dataService.fetchModel(from: url) { (result: Result<WeatherResponse, Error>) in
                       switch result {
                       case .success(let weatherResponse):
                           do {
                               let encoder = JSONEncoder()
                               let data = try encoder.encode(weatherResponse)
                               self.cacheManager.saveToCache(cachePath: self.cachePath, data: data)
                           } catch {
                               print("Error encoding data:", error)
                           }
                           
                           completion(.success(weatherResponse))
                           
                       case .failure(let error):
                           print("Network error:", error)
                           completion(.failure(error))
                       }
                   }
               } else {
                   print("Местоположение еще не определено")
               }
        } else {
            print("data from cach: ")
            if let cachedData = cacheManager.loadFromCache(cachePath: cachePath) {
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(WeatherResponse.self, from: cachedData)
                    print("success:", result)
                    completion(.success(result))
                } catch {
                    print("Error:", error)
                    completion(.failure(error))
                }
            } else {
                completion(.failure(NSError(domain: "No internet connection and no cached data", code: 0, userInfo: nil)))
            }
        }
    }
}
