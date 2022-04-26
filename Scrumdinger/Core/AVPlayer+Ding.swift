//
//  AVPlayer+Ding.swift
//  Scrumdinger
//
//  Created by Ahmed Abaza on 26/04/2022.
//

import AVFoundation

extension AVPlayer {
    static let sharedDingPlayer: AVPlayer = {
        guard let url = Bundle.main.url(forResource: "ding", withExtension: "wav") else { fatalError("Failed to find sound file.") }
        return AVPlayer(url: url)
    }()
}
