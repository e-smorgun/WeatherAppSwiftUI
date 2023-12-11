//
//  DataConverter.swift
//  WeatherAppSwiftUI
//
//  Created by Evgeny on 7.12.23.
//

import Foundation

class DateConverter {
    
    func convertDateToTime(_ dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if let date = inputFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "HH:mm"
            let resultString = outputFormatter.string(from: date)
            return resultString
        } else {
            return "error"
        }
    }
    
    func convertDateToDays(_ dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if let date = inputFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "dd MMM"
            let resultString = outputFormatter.string(from: date)
            return resultString
        } else {
            return "error"
        }
    }
}
