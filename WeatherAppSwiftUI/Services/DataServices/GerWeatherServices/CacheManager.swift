//
//  CacheManager.swift
//  WeatherAppSwiftUI
//
//  Created by Evgeny on 10.12.23.
//

import Foundation

class CacheManager {
    private let timerManager = TimerManager()
    
    func saveToCache(cachePath: URL, data: Data) {
        do {
            try data.write(to: cachePath)
            UserDefaults.standard.set(Date(), forKey: "Date")
        } catch {
            print("Failed to write to cache: \(error)")
        }
    }
    
    func loadFromCache(cachePath: URL) -> Data? {
        do {
            let data = try Data(contentsOf: cachePath)
            return data
        } catch {
            return nil
        }
    }
}
