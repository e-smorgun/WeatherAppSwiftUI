//
//  BackgroundVideoView.swift
//  WeatherAppSwiftUI
//
//  Created by Evgeny on 9.12.23.
//

import Foundation
import SwiftUI
import AVKit

struct BackgroundVideoView: View {
    private var player: AVPlayer {
        AVPlayer(url: Bundle.main.url(forResource: "Clear", withExtension: "mp4")!)
    }
    
    var body: some View {
        VideoPlayer(player: player) {
            // Кастом
        }.onAppear() {
            player.play()
        }
        .onDisappear() {
            player.pause()
        }
        .edgesIgnoringSafeArea(.all)
    }
}
