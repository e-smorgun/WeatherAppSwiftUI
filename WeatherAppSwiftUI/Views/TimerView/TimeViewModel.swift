//
//  TimeViewModel.swift
//  WeatherAppSwiftUI
//
//  Created by Evgeny on 10.12.23.
//

import Foundation

class TimeElapsedViewModel: ObservableObject {
    @Published var elapsedTime: String = ""

    private var startDate: Date?

    init() {
            startDate = UserDefaults.standard.object(forKey: "Date") as? Date
            updateElapsedTime()

        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.updateElapsedTime()
        }
    }

    private func updateElapsedTime() {
        guard let startDate = startDate else { return }
        let currentDate = Date()
        let elapsedTime = currentDate.timeIntervalSince(startDate)

        if elapsedTime < 60 {
            self.elapsedTime = String(format: "%.0f сек", elapsedTime)
        } else if elapsedTime < 3600 {
            let minutes = Int(elapsedTime / 60)
            self.elapsedTime = ">\(minutes) мин"
        } else if elapsedTime < 86400 {
            let hours = Int(elapsedTime / 3600)
            self.elapsedTime = ">\(hours) ч"
        } else {
            let days = Int(elapsedTime / 86400)
            self.elapsedTime = ">\(days) д"
        }
    }
}
