//
//  HourlyCell.swift
//  WeatherAppSwiftUI
//
//  Created by Evgeny on 9.12.23.
//

import Foundation
import SwiftUI

struct HourlyCell: View {
    let hourlyWeather: HourlyWeatherData
    
    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            Text(hourlyWeather.date)
                .font(.system(size: 16, weight: .regular))
            
            Image(hourlyWeather.imageID)
                .resizable()
                .frame(width: 50, height: 50)
            
            Text("\(Int(hourlyWeather.weatherCondition - (Locale.current.language.languageCode?.identifier == "ru" ? 273.15 : 0)))\(NSLocalizedString("Degree Key", comment: "Degree Key"))")
                .font(.system(size: 20, weight: .regular))
                .padding(.leading, 5)
        }
    }
}

#Preview {
    WeatherView()
}
