//
//  LoginRegisterView.swift
//  DrumsPracticePlayer
//
//  Created by Bruno Vieira on 19/03/19.
//  Copyright © 2019 Bruno Vieira. All rights reserved.
//

import UIKit

protocol LoginRegisterViewDelegate: NSObjectProtocol {
    func loginRegisterButtonDidReceiveTouchUpInside()
}

class LoginRegisterView: UIView {
    // delegates
    weak var delegate: LoginRegisterViewDelegate? {
        didSet {
            confirmButton.addTarget(delegate, action: Selector(("loginRegisterButtonDidReceiveTouchUpInside")), for: .touchUpInside)
        }
    }
    weak var textFieldDelegate: UITextFieldDelegate? {
        didSet {
            usernameTextField.delegate = textFieldDelegate
            emailTextField.delegate = textFieldDelegate
            passwordTextField.delegate = textFieldDelegate
            confirmPasswordTextField.delegate = textFieldDelegate
        }
    }
    
    // constraints
    weak var logoTitleContainerViewCenterYConstraint: NSLayoutConstraint?
    weak var emailTextFieldTopDistanceConstraint: NSLayoutConstraint?
    weak var passwordTextFieldBottomDistanceConstraint: NSLayoutConstraint?
    
    // ui elements
    lazy var scrollView: UIKeyboardScrollView = {
        let sv = UIKeyboardScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    lazy var contentView: UIView = {
       let content = UIView()
        content.translatesAutoresizingMaskIntoConstraints = false
        return content
    }()
    
    lazy var logoTitleContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var logoImageView: UIImageView = {
        let logo = UIImageView(image: UIImage(named: "logo"))
        logo.translatesAutoresizingMaskIntoConstraints = false
        return logo
    }()
    
    lazy var titleLabel: UILabel = {
        let title = UILabel()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        title.attributedText = NSAttributedString(string: "Drums Practice\nPlayer",
                                                  attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle,
                                                               NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25.0, weight: .bold),
                                                               NSAttributedString.Key.foregroundColor: UIColor.light_green])
        title.numberOfLines = 0
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "email"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "password"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var confirmPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "password confirmation"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "username"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var loginRegisterSegmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["LOGIN", "REGISTER"])
        control.selectedSegmentIndex = 0
        control.tintColor = .dark_green
        control.addTarget(self, action: #selector(loginRegisterSegmentedControlValueChanged), for: UIControl.Event.valueChanged)
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("LOGIN", for: .normal)
        button.setTitleColor(.light_green, for: .normal)
        button.backgroundColor = .dark_green
        button.layer.cornerRadius = 5.0
        button.alpha = 1.0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var loginInterfaceContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .light_green
        view.layer.cornerRadius = 5.0
        view.alpha = 0.0
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // intialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // layout setup
    fileprivate func setupView() {        
        addSubview(scrollView)
        scrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        scrollView.addSubview(contentView)
        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        backgroundColor = .dark_green
        setupLogoTitleContainerView()
        setupLoginInterfaceContainerView()
    }
    
    fileprivate func setupLogoTitleContainerView() {
        // container
        contentView.addSubview(logoTitleContainerView)
        logoTitleContainerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        logoTitleContainerViewCenterYConstraint = logoTitleContainerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 55)
        logoTitleContainerViewCenterYConstraint?.isActive = true
        logoTitleContainerView.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor).isActive = true
        logoTitleContainerView.heightAnchor.constraint(lessThanOrEqualTo: contentView.heightAnchor).isActive = true
        
        // logo imageview
        logoTitleContainerView.addSubview(logoImageView)
        logoImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        logoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor).isActive = true
        logoImageView.centerXAnchor.constraint(equalTo: logoTitleContainerView.centerXAnchor).isActive = true
        
        // title label
        logoTitleContainerView.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 50).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: logoTitleContainerView.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: logoTitleContainerView.trailingAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: logoTitleContainerView.bottomAnchor).isActive = true
    }
    
    fileprivate func setupLoginInterfaceContainerView() {
        // container
        contentView.addSubview(loginInterfaceContainerView)
        loginInterfaceContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        loginInterfaceContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        loginInterfaceContainerView.topAnchor.constraint(equalTo: logoTitleContainerView.bottomAnchor, constant: 50).isActive = true
        loginInterfaceContainerView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -20).isActive = true
        
        // segmented control
        loginInterfaceContainerView.addSubview(loginRegisterSegmentedControl)
        loginRegisterSegmentedControl.leadingAnchor.constraint(equalTo: loginInterfaceContainerView.leadingAnchor, constant: 1).isActive = true
        loginRegisterSegmentedControl.trailingAnchor.constraint(equalTo: loginInterfaceContainerView.trailingAnchor, constant: -1).isActive = true
        loginRegisterSegmentedControl.topAnchor.constraint(equalTo: loginInterfaceContainerView.topAnchor, constant: 1).isActive = true
        loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        // email textfield
        loginInterfaceContainerView.addSubview(emailTextField)
        emailTextField.heightAnchor.constraint(equalToConstant: 25).isActive = true
        emailTextField.leadingAnchor.constraint(equalTo: loginInterfaceContainerView.leadingAnchor, constant: 5).isActive = true
        emailTextField.trailingAnchor.constraint(equalTo: loginInterfaceContainerView.trailingAnchor, constant: -5).isActive = true
        emailTextFieldTopDistanceConstraint = emailTextField.topAnchor.constraint(equalTo: loginRegisterSegmentedControl.bottomAnchor, constant: 10)
        emailTextFieldTopDistanceConstraint?.isActive = true

        // password textfield
        loginInterfaceContainerView.addSubview(passwordTextField)
        passwordTextField.heightAnchor.constraint(equalToConstant: 25).isActive = true
        passwordTextField.leadingAnchor.constraint(equalTo: loginInterfaceContainerView.leadingAnchor, constant: 5).isActive = true
        passwordTextField.trailingAnchor.constraint(equalTo: loginInterfaceContainerView.trailingAnchor, constant: -5).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 5).isActive = true
        
        // confirm button
        loginInterfaceContainerView.addSubview(confirmButton)
        confirmButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        confirmButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        confirmButton.centerXAnchor.constraint(equalTo: loginInterfaceContainerView.centerXAnchor).isActive = true
        confirmButton.bottomAnchor.constraint(equalTo: loginInterfaceContainerView.bottomAnchor, constant: -20).isActive = true
        
        passwordTextFieldBottomDistanceConstraint = confirmButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20)
        passwordTextFieldBottomDistanceConstraint?.isActive = true
        
        // username textfield
        loginInterfaceContainerView.addSubview(usernameTextField)
        usernameTextField.heightAnchor.constraint(equalToConstant: 25).isActive = true
        usernameTextField.leadingAnchor.constraint(equalTo: loginInterfaceContainerView.leadingAnchor, constant: 5).isActive = true
        usernameTextField.trailingAnchor.constraint(equalTo: loginInterfaceContainerView.trailingAnchor, constant: -5).isActive = true
        usernameTextField.bottomAnchor.constraint(equalTo: emailTextField.topAnchor, constant: -5).isActive = true
        usernameTextField.isHidden = true
        
        // confirm password textfield
        loginInterfaceContainerView.addSubview(confirmPasswordTextField)
        confirmPasswordTextField.heightAnchor.constraint(equalToConstant: 25).isActive = true
        confirmPasswordTextField.leadingAnchor.constraint(equalTo: loginInterfaceContainerView.leadingAnchor, constant: 5).isActive = true
        confirmPasswordTextField.trailingAnchor.constraint(equalTo: loginInterfaceContainerView.trailingAnchor, constant: -5).isActive = true
        confirmPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 5).isActive = true
        confirmPasswordTextField.isHidden = true
    }
    
    // animations
    public func animateLoginInterface() {
        logoTitleContainerViewCenterYConstraint?.constant = -60
        UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseInOut, animations: {
            self.layoutIfNeeded()
        }) { (_) in
            UIView.animate(withDuration: 0.5, animations: {
                self.loginInterfaceContainerView.alpha = 1.0
            }, completion: { (_) in
                self.loginInterfaceContainerView.isUserInteractionEnabled = true
            })
        }
    }
    
    public func resetLayout() {
//        setupView()
    }
    
    // actions
    @objc func loginRegisterSegmentedControlValueChanged() {
        switch loginRegisterSegmentedControl.selectedSegmentIndex {
        case 0:
            UIView.animate(withDuration: 0.3, delay: 0.2, animations: {
                self.loginInterfaceContainerView.alpha = 0.0
            }) { (_) in
                self.passwordTextFieldBottomDistanceConstraint?.constant = 20
                self.emailTextFieldTopDistanceConstraint?.constant = 10
                self.loginInterfaceContainerView.layoutIfNeeded()
                self.usernameTextField.isHidden = true
                self.confirmPasswordTextField.isHidden = true
                self.confirmButton.setTitle("LOGIN", for: .normal)
                UIView.animate(withDuration: 0.25, animations: {
                    self.loginInterfaceContainerView.alpha = 1.0
                })
            }
        case 1:
            UIView.animate(withDuration: 0.3, delay: 0.2, animations: {
                self.loginInterfaceContainerView.alpha = 0.0
            }) { (_) in
                self.passwordTextFieldBottomDistanceConstraint?.constant = 50
                self.emailTextFieldTopDistanceConstraint?.constant = 40
                self.loginInterfaceContainerView.layoutIfNeeded()
                self.usernameTextField.isHidden = false
                self.confirmPasswordTextField.isHidden = false
                self.confirmButton.setTitle("REGISTER", for: .normal)
                UIView.animate(withDuration: 0.25, animations: {
                    self.loginInterfaceContainerView.alpha = 1.0
                })
            }
        default:
            ()
        }
    }
}
