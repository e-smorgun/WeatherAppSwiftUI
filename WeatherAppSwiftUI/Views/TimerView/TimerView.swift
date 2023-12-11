//
//  TimerView.swift
//  WeatherAppSwiftUI
//
//  Created by Evgeny on 10.12.23.
//

import Foundation
import SwiftUI

struct TimeView: View {
    @StateObject private var viewModel = TimeElapsedViewModel()
    
    var body: some View {
        ZStack {
            Color.white
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 5) {
                Text(NSLocalizedString("No Internet Connection Key", comment: "No Internet Connection"))
                    .font(.headline)
                
                Text(String(format: NSLocalizedString("Last update  Key", comment: "Last update"), viewModel.elapsedTime))
                    .font(.subheadline)
            }
        }
    }
}


#Preview {
    WeatherView()
}
