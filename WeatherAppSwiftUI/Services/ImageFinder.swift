//
//  ImageFounder.swift
//  WeatherAppSwiftUI
//
//  Created by Evgeny on 10.12.23.
//

import Foundation

class ImageFinder {
    private let dateService = DateService()
    
    private func mostFrequentImage(in array: [String]) -> String? {
        guard !array.isEmpty else {
            return nil
        }

        var elementCountDictionary: [String: Int] = [:]

        for element in array {
            elementCountDictionary[element, default: 0] += 1
        }

        let mostFrequentElements = elementCountDictionary.filter { $0.value == elementCountDictionary.values.max() }

        if let randomElement = mostFrequentElements.randomElement() {
            return randomElement.key
        }

        return nil
    }
    
    func findImageByData(date: String, dataList: [List]) -> String {
        var modifiedList = dateService.convertDataInArray(dataList: dataList)
        
        modifiedList = modifiedList.filter { $0.dtTxt == date }
            
        return mostFrequentImage(in: modifiedList.map { $0.weather.first!.icon }) ?? "Error"
    }
}
