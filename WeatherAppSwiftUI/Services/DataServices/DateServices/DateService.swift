//
//  DateFinder.swift
//  WeatherAppSwiftUI
//
//  Created by Evgeny on 9.12.23.
//

import Foundation

struct DateService {
    private let dateConverter = DateConverter()
    
    func dateFinder(dates: [String]) -> [String] {
        var returnDates: [String] = []
        
        for date in dates {
            let bufferDate = dateConverter.convertDateToDays(date)
            
            if !returnDates.contains(bufferDate) {
                returnDates.append(bufferDate)
            }
        }
        
        return returnDates
    }
    
    func convertDataInArray(dataList: [List]) -> [List] {
        var modifiedList = dataList
        
        for index in modifiedList.indices {
            modifiedList[index].dtTxt = dateConverter.convertDateToDays(modifiedList[index].dtTxt)
        }
        
        return modifiedList
    }
}
