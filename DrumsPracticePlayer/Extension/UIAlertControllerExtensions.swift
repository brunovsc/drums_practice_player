//
//  UIAlertControllerExtensions.swift
//  DrumsPracticePlayer
//
//  Created by Bruno Vieira on 04/03/19.
//  Copyright © 2019 Bruno Vieira. All rights reserved.
//

import UIKit

extension UIAlertController {
    static func showErrorDialog(title: String, message: String, buttonTitle: String, buttonAction: (() -> ())?, onController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .cancel, handler: { (action) in
            buttonAction?()
        }))
        onController.show(alert, sender: nil)
    }
}
