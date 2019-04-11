//
//  LoginViewController.swift
//  DrumsPracticePlayer
//
//  Created by Bruno Vieira on 19/03/19.
//  Copyright © 2019 Bruno Vieira. All rights reserved.
//

import UIKit

class LoginRegisterViewController: UIViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    lazy var loginRegisterView = LoginRegisterView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = loginRegisterView
        loginRegisterView.textFieldDelegate = self
        loginRegisterView.delegate = self
        navigationController?.navigationBar.tintColor = .dark_green
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateLoginInterface()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.loginRegisterView.logoTitleContainerView.alpha = 1.0
        self.loginRegisterView.loginInterfaceContainerView.alpha = 1.0
    }
    
    fileprivate func animateLoginInterface() {
        loginRegisterView.animateLoginInterface()
    }
}

extension LoginRegisterViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        loginRegisterView.scrollView.activeField = textField
        loginRegisterView.scrollView.lastOffset = loginRegisterView.scrollView.contentOffset
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        loginRegisterView.scrollView.activeField?.resignFirstResponder()
        loginRegisterView.scrollView.activeField = nil
        return true
    }
}

extension LoginRegisterViewController: LoginRegisterViewDelegate {
    @objc func loginRegisterButtonDidReceiveTouchUpInside() {
        UIView.animate(withDuration: 0.25, animations: {
            self.loginRegisterView.logoTitleContainerView.alpha = 0.0
            self.loginRegisterView.loginInterfaceContainerView.alpha = 0.0
        }) { (_) in
            let transition = CATransition()
            transition.duration = 0.25
            transition.type = .fade
            self.navigationController?.view.layer.add(transition, forKey: nil)
            self.navigationController?.pushViewController(HomeViewController(), animated: false)
        }
    }
}
