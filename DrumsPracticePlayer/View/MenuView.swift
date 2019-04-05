//
//  MenuView.swift
//  DrumsPracticePlayer
//
//  Created by Bruno Vieira on 02/04/19.
//  Copyright © 2019 Bruno Vieira. All rights reserved.
//

import UIKit

protocol MenuViewDelegate {
    func metronomeButtonDidReceiveTouchUpInside()
    func playlistButtonDidReceiveTouchUpInside()
    func refreshButtonDidReceiveTouchUpInside()
    func settingsButtonDidReceiveTouchUpInside()
}

class MenuView: UIView {
    
    static let buttonSize: CGFloat = 50

    var delegate: MenuViewDelegate?
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var metronomeButton: UIButton = {
        return UIButton.roundButton(imageName: "metronome", size: MenuView.buttonSize, target: self, selector: #selector(metronomeButtonDidReceiveTouchUpInside))
    }()
    
    lazy var playlistButton: UIButton = {
        return UIButton.roundButton(imageName: "playlist", size: MenuView.buttonSize, target: self, selector: #selector(playlistButtonDidReceiveTouchUpInside))
    }()
    
    lazy var refreshButton: UIButton = {
        return UIButton.roundButton(imageName: "refresh", size: MenuView.buttonSize, target: self, selector: #selector(refreshButtonDidReceiveTouchUpInside))
    }()
    
    lazy var settingsButton: UIButton = {
        return UIButton.roundButton(imageName: "settings", size: MenuView.buttonSize, target: self, selector: #selector(settingsButtonDidReceiveTouchUpInside))
    }()
    
    @objc func metronomeButtonDidReceiveTouchUpInside() {
        delegate?.metronomeButtonDidReceiveTouchUpInside()
    }
    
    @objc func playlistButtonDidReceiveTouchUpInside() {
        delegate?.playlistButtonDidReceiveTouchUpInside()
    }
    
    @objc func refreshButtonDidReceiveTouchUpInside() {
        delegate?.refreshButtonDidReceiveTouchUpInside()
    }
    
    @objc func settingsButtonDidReceiveTouchUpInside() {
        delegate?.settingsButtonDidReceiveTouchUpInside()
    }
    
    convenience init(delegate: MenuViewDelegate) {
        self.init()
        self.delegate = delegate
        setupView()
    }
    
    func setupView() {
        backgroundColor = .light_green
        addSubview(containerView)
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        containerView.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        
        // buttons
        containerView.addSubview(playlistButton)
        playlistButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10).isActive = true
        playlistButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10).isActive = true
        
        containerView.addSubview(metronomeButton)
        metronomeButton.trailingAnchor.constraint(equalTo: playlistButton.leadingAnchor, constant: -30).isActive = true
        metronomeButton.centerYAnchor.constraint(equalTo: playlistButton.centerYAnchor).isActive = true
        metronomeButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10).isActive = true
        
        containerView.addSubview(settingsButton)
        settingsButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10).isActive = true
        settingsButton.topAnchor.constraint(equalTo: playlistButton.bottomAnchor, constant: 30).isActive = true
        settingsButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10).isActive = true
        
        containerView.addSubview(refreshButton)
        refreshButton.trailingAnchor.constraint(equalTo: settingsButton.leadingAnchor, constant: -30).isActive = true
        refreshButton.centerYAnchor.constraint(equalTo: settingsButton.centerYAnchor).isActive = true
        refreshButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10).isActive = true        
    }
}
