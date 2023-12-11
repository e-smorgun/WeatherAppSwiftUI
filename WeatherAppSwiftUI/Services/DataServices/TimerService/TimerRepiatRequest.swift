//
//  TimerRepiatRequest.swift
//  WeatherAppSwiftUI
//
//  Created by Evgeny on 11.12.23.
//

import Foundation

class TimerRepiatRequest: ObservableObject {
    @Published var timer: Timer?
    
    func startTimer(duration: TimeInterval, action: @escaping () -> Void) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: duration, repeats: false) { _ in
            action()
        }
    }
}
