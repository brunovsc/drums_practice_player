//
//  TimeIntervalExtensions.swift
//  DrumsPracticePlayer
//
//  Created by Bruno Vieira on 11/04/19.
//  Copyright © 2019 Bruno Vieira. All rights reserved.
//

import Foundation

extension TimeInterval {
    func asMinutesAndSeconds() -> String {
        let minutes = (Int)(self / 60.0)
        let seconds = (Int)(self - (Double(minutes * 60)))
        let timeString = String(format: "%02d:%02d", minutes, seconds)
        return timeString
    }
}
