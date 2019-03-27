//
//  UIScrollViewExtensions.swift
//  DrumsPracticePlayer
//
//  Created by Bruno Vieira on 19/03/19.
//  Copyright © 2019 Bruno Vieira. All rights reserved.
//

import UIKit
import Foundation

class UIKeyboardScrollView: UIScrollView {
    weak var activeField: UIView?
    weak var constraintContentHeight: NSLayoutConstraint?
    var keyboardHeight: CGFloat?
    var lastOffset: CGPoint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        registerForKeyboardNotifications()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIWindow.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIWindow.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if keyboardHeight != nil {
            return
        }
        if let keyboardSize = (notification.userInfo?[UIWindow.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardSize.height
            
            UIView.animate(withDuration: 0.3, animations: {
                self.constraintContentHeight?.constant += keyboardSize.height
            })
            
            guard let activeField = activeField else { return }
            guard let globalPoint = activeField.superview?.convert(activeField.frame.origin, to: nil) else { return }
            let distanceToBottom = self.frame.size.height - globalPoint.y - activeField.frame.size.height
            let collapseSpace = keyboardSize.height - distanceToBottom
            if collapseSpace < 0 {
                return
            }
            
            UIView.animate(withDuration: 0.3, animations: {
                self.contentOffset = CGPoint(x: self.lastOffset?.x ?? 0, y: collapseSpace + 10)
            })
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        guard let kbHeight = keyboardHeight else { return }
        UIView.animate(withDuration: 0.3) {
            self.constraintContentHeight?.constant -= kbHeight
            self.contentOffset = self.lastOffset ?? CGPoint.zero
        }
        keyboardHeight = nil
    }
}
