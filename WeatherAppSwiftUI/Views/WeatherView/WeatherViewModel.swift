//
//  WeatherViewModel.swift
//  WeatherAppSwiftUI
//
//  Created by Evgeny on 8.12.23.
//

import Foundation

class WeatherViewModel: ObservableObject {
    private let weatherService: CurrentWeatherService
    private let futureWeatherService: FutureWeatherService
    private let dateConverter: DateConverter
    private let findTemperature: FindTemperature
    private let dateFinder: DateService
    private let imageFinder: ImageFinder
    private let coordinateService: CoordinateFounder
    private let locationManager: LocationManager
    var currentCity: String = ""

    @Published var errorMessage: String?
    @Published var currentWeather: [Weather] = []
    @Published var currentTemp: Double = 0.0
    @Published var highTemp: Double = 0.0
    @Published var lowTemp: Double = 0.0
    @Published var currentWeatherCondition: String = ""
    @Published var hourlyWeatherData: [HourlyWeatherData] = []
    @Published var dailyWeatherData: [DailyWeatherData] = []
    @Published var isLoading: Bool = false
    @Published var searchCityName: String = ""
    @Published var hasLocationPermission: Bool = false
    
    init(
        weatherService: CurrentWeatherService = CurrentWeatherService(),
        futureWeatherService: FutureWeatherService = FutureWeatherService(),
        dateConverter: DateConverter = DateConverter(),
        findTemperature: FindTemperature = FindTemperature(),
        dateFinder: DateService = DateService(),
        imageFinder: ImageFinder = ImageFinder(),
        coordinateService: CoordinateFounder = CoordinateFounder(),
        locationManager: LocationManager = LocationManager()
    ) {
        self.weatherService = weatherService
        self.futureWeatherService = futureWeatherService
        self.dateConverter = dateConverter
        self.findTemperature = findTemperature
        self.dateFinder = dateFinder
        self.imageFinder = imageFinder
        self.coordinateService = coordinateService
        self.locationManager = locationManager
    }
    
    private func loadCityData(place: String, completion: @escaping () -> Void) {
        coordinateService.fetchCoordinate(place: place) { [weak self] result in
            switch result {
            case .success(let response):
                self?.weatherService.fetchWeatherByCoordinates(lat: (response.location?.lat)!, lon: (response.location?.lon)!) { [weak self] result in
                    switch result {
                    case .success(let response):
                        DispatchQueue.main.async { [self] in
                            if let weather = response.weather {
                                self?.currentWeather = response.weather!
                                self?.currentWeatherCondition = "\((weather.first?.main)!), \((weather.first?.description)!)"
                            }
                            
                            if let temperature = response.main {
                                self?.currentTemp = temperature.temp - (Locale.current.language.languageCode?.identifier == "ru" ? 273.15 : 0)
                                self?.highTemp = temperature.tempMax - (Locale.current.language.languageCode?.identifier == "ru" ? 273.15 : 0)
                                self?.lowTemp = temperature.tempMin - (Locale.current.language.languageCode?.identifier == "ru" ? 273.15 : 0)
                            }
                            completion()
                        }
                    case .failure(let error):
                        DispatchQueue.main.async { [self] in
                            self?.errorMessage = error.localizedDescription
                        }
                    }
                }
                completion()
            case .failure(let error):
                DispatchQueue.main.async { [self] in
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    private func loadCityDailyData(place: String, completion: @escaping () -> Void) {
        coordinateService.fetchCoordinate(place: place) { [weak self] result in
            switch result {
            case .success(let response):
                self?.futureWeatherService.fetchWeatherByCoordinates(lat: (response.location?.lat)!, lon: (response.location?.lon)!) { [weak self] result in
                    switch result {
                    case .success(let response):
                        self?.writeHourlyWeatherData(dataList: response.list!)
                        self?.writeDailyWeatherData(dataList: response.list!)
                        completion()
                    case .failure(let error):
                        DispatchQueue.main.async { [self] in
                            self?.errorMessage = error.localizedDescription
                        }
                    }
                }
                completion()
            case .failure(let error):
                DispatchQueue.main.async { [self] in
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    private func writeHourlyWeatherData(dataList: [List]) {
        DispatchQueue.main.async { [self] in
            hourlyWeatherData.removeAll()
        }
        for index in 0...7 {
            DispatchQueue.main.async { [self] in
                hourlyWeatherData.append(HourlyWeatherData(date: dateConverter.convertDateToTime(dataList[index].dtTxt),
                                                           imageID: dataList[index].weather.first?.icon ?? "Error",
                                                           weatherCondition: dataList[index].main.temp))
            }
        }
    }
    
    private func getDates(dataList: [List]) -> [String] {
        var dates: [String] = []
        
        for data in dataList {
            dates.append(data.dtTxt)
        }
        
        return dateFinder.dateFinder(dates: dates)
    }
    
    private func writeDailyWeatherData(dataList: [List]) {
        DispatchQueue.main.async { [self] in
            dailyWeatherData.removeAll()
        }
        let dates: [String] = getDates(dataList: dataList)
        
        for index in 1...4 {
            DispatchQueue.main.async { [self] in
                dailyWeatherData.append(DailyWeatherData(date: dates[index],
                                                         imageID: imageFinder.findImageByData(date: dates[index], dataList: dataList),
                                                         minTemp: findTemperature.findMinTemperature(date: dates[index], dataList: dataList) - (Locale.current.language.languageCode?.identifier == "ru" ? 273.15 : 0),
                                                         maxTemp: findTemperature.findMaxTemperature(date: dates[index], dataList: dataList) - (Locale.current.language.languageCode?.identifier == "ru" ? 273.15 : 0)))
            }
        }
    }
    
    private func loadFutureData(completion: @escaping () -> Void) {
        futureWeatherService.fetchCurrentLocationWeather { [weak self] result in
            switch result {
            case .success(let response):
                self?.writeHourlyWeatherData(dataList: response.list!)
                self?.writeDailyWeatherData(dataList: response.list!)
                completion()
            case .failure(let error):
                DispatchQueue.main.async { [self] in
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    private func loadCurrentData(completion: @escaping () -> Void) {
        weatherService.fetchCurrentLocationWeather { [weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async { [self] in
                    if let weather = response.weather {
                        self?.currentWeather = response.weather!
                        self?.currentWeatherCondition = "\((weather.first?.main)!), \((weather.first?.description)!)"
                    }
                    
                    if let temperature = response.main {
                        self?.currentTemp = temperature.temp - (Locale.current.language.languageCode?.identifier == "ru" ? 273.15 : 0)
                        self?.highTemp = temperature.tempMax - (Locale.current.language.languageCode?.identifier == "ru" ? 273.15 : 0)
                        self?.lowTemp = temperature.tempMin - (Locale.current.language.languageCode?.identifier == "ru" ? 273.15 : 0)
                    }
                    completion()
                }
            case .failure(let error):
                DispatchQueue.main.async { [self] in
                    self?.errorMessage = error.localizedDescription
                    print("SADSDA", self?.errorMessage)
                }
            }
        }
    }
    
    func checkLocationPermission() -> Bool {
        hasLocationPermission = locationManager.checkLocationPermission()
        return hasLocationPermission
    }
    
    func loadCurrentCityData(place: String) {
        currentCity = searchCityName
        isLoading = true
        
        loadCityData(place: place, completion: {
            self.loadCityDailyData(place: place, completion: { [self] in
                isLoading = false
            }) 
        })
    }
    
    func loadData() {
        isLoading = true
        
        loadCurrentData {
            print("Error Massage:", self.errorMessage)
            self.loadFutureData { [self] in
                isLoading = false
            }
        }
    }
}
