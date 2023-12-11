//
//  DailyCell.swift
//  WeatherAppSwiftUI
//
//  Created by Evgeny on 9.12.23.
//

import Foundation
import SwiftUI

struct DailyCell: View {
    let dailyWeather: DailyWeatherData
    
    var body: some View {
        HStack {
            Text(dailyWeather.date)
            
            Spacer()
            
            Image(dailyWeather.imageID)
            
            Spacer()
            
            Text("\(NSLocalizedString("Low Temperature Key", comment: "Low Temperature Key")): \(Int(dailyWeather.minTemp))\(NSLocalizedString("Degree Key", comment: "Degree Key")) - \(NSLocalizedString("High Temperature Key", comment: "High Temperature Key")): \(Int(dailyWeather.maxTemp))\(NSLocalizedString("Degree Key", comment: "Degree Key"))")
            
        }
    }
}

#Preview {
    WeatherView()
}
