//
//  UIButtonExtensions.swift
//  DrumsPracticePlayer
//
//  Created by Bruno Vieira on 19/03/19.
//  Copyright © 2019 Bruno Vieira. All rights reserved.
//

import UIKit

extension UIButton {
    static func roundButton(imageName: String, size: CGFloat, target: Any, selector: Selector) -> UIButton {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.addTarget(target, action: selector, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: size).isActive = true
        button.widthAnchor.constraint(equalToConstant: size).isActive = true
        return button
    }
}
