//
//  WeatherView.swift
//  WeatherAppSwiftUI
//
//  Created by Evgeny on 8.12.23.
//

import SwiftUI
import Combine

struct WeatherView: View {
    @ObservedObject var viewModel = WeatherViewModel()
    @StateObject private var timerManager = TimerManager()
    @StateObject private var timerRepiatRequest = TimerRepiatRequest()

    private let startColor: Color = .clear
    private let endColor: Color = .cyan
    
    private let titleFont: Font = .system(size: 32, weight: .medium)
    private let temperatureFont: Font = .system(size: 84, weight: .light)
    private let conditionFont: Font = .system(size: 16, weight: .medium)
    
    var body: some View {
        ZStack {
            backgroundGradient
                .onAppear {
                    viewModel.checkLocationPermission()
                }

            if viewModel.hasLocationPermission == true {
                mainView
            } else {
                locationNotAvalible
            }
        }
    }
    
    private var mainView: some View {
        ZStack {
            if viewModel.isLoading {
                VStack {
                    loadingView
                        .padding(.vertical, 20)
                    Text("Remember, crime prediction works better than weather prediction these days...")
                        .multilineTextAlignment(.center)
                }
            } else {
                VStack {
                    if !Reachability.isConnectedToNetwork() {
                        TimeView()
                            .frame(height: 35)
                    }
                    weatherContentView
                    searchView
                }
            }
        }
        .onAppear {
            if viewModel.hasLocationPermission == true {
                viewModel.loadData()
            } 
        }
    }
    
    private var searchView: some View {
        HStack {
            TextField("Enter city name", text: $viewModel.searchCityName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding([.leading, .trailing], 16)
            
            Button(action: {
                viewModel.loadCurrentCityData(place: viewModel.searchCityName)
            }) {
                Text("Search")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.trailing, 16)
        }
        .padding(.vertical, 10)
    }
    
    private var loadingView: some View {
        VStack {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .black))
                .scaleEffect(1.5)
            Text("Loading Key")
                .foregroundColor(.black)
                .padding(.top, 10)
            
        }
    }
    
    private var locationNotAvalible: some View {
        VStack {
            Text("Not Permission Key")
                .foregroundColor(.black)
                .padding(.top, 10)
            
            Button(action: {
                viewModel.checkLocationPermission()
                if viewModel.hasLocationPermission == true {
                    viewModel.loadData()
                }
            }) {
                Text("Retry Key")
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.top, 20)
            .disabled(timerRepiatRequest.timer != nil)
        }
    }
    
    private var weatherContentView: some View {
        ScrollView {
            locationTitle
                .padding(.top, 20)
            currentTemperature
            currentWeatherCondition
            highLowTemperatures
            hourlyCarousel
            dailyCarousel
        }
        .background(backgroundGradient)
    }
    
    var locationTitle: some View {
        if viewModel.currentCity == "" {
            Text(NSLocalizedString("Current Location Key", comment: "Current Location"))
                .font(titleFont)
                .multilineTextAlignment(.center)
        } else {
            Text(viewModel.searchCityName)
                .font(titleFont)
                .multilineTextAlignment(.center)
        }
    }
    
    var currentTemperature: some View {
        Text("\(Int(viewModel.currentTemp))\(NSLocalizedString("Degree Key", comment: "Degree Key"))")
            .font(temperatureFont)
            .padding(.leading, 30)
    }
    
    
    var currentWeatherCondition: some View {
        Text("\(viewModel.currentWeatherCondition)")
            .font(conditionFont)
    }
    
    var highLowTemperatures: some View {
        HStack {
            Text("\(NSLocalizedString("High Temperature Key", comment: "High Temperature Key")): \(Int(viewModel.highTemp))\(NSLocalizedString("Degree Key", comment: "Degree Key"))")
                .font(conditionFont)
            Text("\(NSLocalizedString("Low Temperature Key", comment: "Low Temperature Key")): \(Int(viewModel.lowTemp))\(NSLocalizedString("Degree Key", comment: "Degree Key"))")
                .font(conditionFont)
        }
    }
    
    var hourlyCarousel: some View {
        VStack(alignment: .leading) {
            Text(NSLocalizedString("24 hours forecast Key", comment: "24 hours forecast"))
            Divider().background(Color.black)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 30) {
                    ForEach(0..<viewModel.hourlyWeatherData.count, id: \.self) { index in
                        HourlyCell(hourlyWeather: viewModel.hourlyWeatherData[index])
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.white)
                .opacity(0.2)
        )
        .padding(.horizontal, 10)
    }
    
    var dailyCarousel: some View {
        VStack(alignment: .leading) {
            Text(NSLocalizedString("4 days forecast Key", comment: "4 days forecast"))
            Divider().background(Color.black)
            VStack {
                ForEach(0..<viewModel.dailyWeatherData.count, id: \.self) { index in
                    DailyCell(dailyWeather: viewModel.dailyWeatherData[index])
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.white)
                .opacity(0.2)
        )
        .padding(.horizontal, 10)
    }
    
    var backgroundGradient: some View {
        LinearGradient(colors: [startColor, endColor], startPoint: .topLeading, endPoint: .bottomTrailing)
            .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    WeatherView()
}
