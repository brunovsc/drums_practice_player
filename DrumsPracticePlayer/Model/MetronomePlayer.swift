//
//  Metronome.swift
//  DrumsPracticePlayer
//
//  Created by Bruno Vieira on 26/03/19.
//  Copyright © 2019 Bruno Vieira. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class MetronomePlayer {
    var metronomeTimer: Timer!
    var metronomeIsOn = false
    var metronomeSoundPlayer: AVAudioPlayer!
    var metronomeAccentPlayer: AVAudioPlayer!
    
    var count: Int = 0
    var tempo: TimeInterval = 60
    var tsUpper: Int = 4
    var tsLower: Int = 4
    
    @IBAction func toggleClick(sender: UIButton) {
        if metronomeIsOn {
            stopMetronome()
        } else {
            startMetronome()
        }
    }
    
    func stopMetronome() {
        metronomeIsOn = false
        metronomeTimer?.invalidate()
        count = 0
    }
    
    func startMetronome() {
        metronomeIsOn = true
        let metronomeTimeInterval: TimeInterval = (240.0 / Double(tsLower)) / tempo
        metronomeTimer = Timer.scheduledTimer(timeInterval: metronomeTimeInterval, target: self, selector: #selector(playMetronomeSound), userInfo: nil, repeats: true)
        metronomeTimer?.fire()
    }
    
    @objc func playMetronomeSound() {
        count += 1
        if count == 1 {
            metronomeAccentPlayer.play()
        } else {
            metronomeSoundPlayer.play()
            if count == tsUpper {
                count = 0
            }
        }
    }
    
    func restartMetronome() {
        if metronomeIsOn {
            stopMetronome()
            startMetronome()
        }
    }
    
    func timeToWait() -> TimeInterval {
        return ((240.0 / Double(tsLower)) / tempo) * (Double(tsUpper) * 0.9)
    }
}
