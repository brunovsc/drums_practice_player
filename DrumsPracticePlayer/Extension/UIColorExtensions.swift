//
//  UIColorExtensions.swift
//  DrumsPracticePlayer
//
//  Created by Bruno Vieira on 04/03/19.
//  Copyright © 2019 Bruno Vieira. All rights reserved.
//

import UIKit

extension UIColor {
    private static func colorWith(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1.0)
    }
    
    static var green = colorWith(red: 44, green: 182, blue: 152) // 2cb698
    static var blue = colorWith(red: 94, green: 177, blue: 191) // 5eb1bf
    static var red = colorWith(red: 220, green: 69, blue: 85) // dc4555
    static var yellow = colorWith(red: 225, green: 160, blue: 23) // e1a017
    static var dark_green = colorWith(red: 4, green: 42, blue: 43) // 042a2b
    static var light_green = colorWith(red: 228, green: 253, blue: 225) // e4fde1
    static var gray = colorWith(red: 84, green: 73, blue: 75) // 54494b
    static var white = colorWith(red: 247, green: 249, blue: 249) // f7f9f9
}
