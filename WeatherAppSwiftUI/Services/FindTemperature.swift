//
//  FindAverageTemp.swift
//  WeatherAppSwiftUI
//
//  Created by Evgeny on 9.12.23.
//

import Foundation

class FindTemperature {
    private let dateService = DateService()

    func findMinTemperature(date: String, dataList: [List]) -> Double {
        var modifiedList = dateService.convertDataInArray(dataList: dataList)

        modifiedList = modifiedList.filter { $0.dtTxt == date }

        return modifiedList.map({ $0.main.tempMin }).min()!
    }
    
    func findMaxTemperature(date: String, dataList: [List]) -> Double {
        var modifiedList = dateService.convertDataInArray(dataList: dataList)

        modifiedList = modifiedList.filter { $0.dtTxt == date }

        return modifiedList.map({ $0.main.tempMax }).max()!
    }
}
