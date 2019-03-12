//
//  PopupPlayerView.swift
//  DrumsPracticePlayer
//
//  Created by Bruno Vieira on 05/03/19.
//  Copyright © 2019 Bruno Vieira. All rights reserved.
//

import UIKit

protocol PopupPlayerViewDelegate {
    func playPauseButtonDidReceiveTouchUpInside()
    func stopButtonDidReceiveTouchUpInside()
    func previousSongButtonDidReceiveTouchUpInside()
    func nextSongButtonDidReceiveTouchUpInside()
    func expandToFullPlayer()
    func reduceToSmallPlayer()
    //    func previousCheckpointButtonDidReceiveTouchUpInside()
    //    func nextCheckpointButtonDidReceiveTouchUpInside()
}

class PopupPlayerView: UIView {
    
    static let minHeight: CGFloat = 140
    static let maxHeight: CGFloat = 500
    static let buttonSize: CGFloat = 40
    
    var isExpanded = false
    weak var containerViewTopConstraint: NSLayoutConstraint?
    var delegate: PopupPlayerViewDelegate?
    
    lazy var containerView: UIView = {
        let container = UIView()
        container.backgroundColor = .light_green
        container.layer.cornerRadius = 10
        container.layer.shadowRadius = 10.0
        container.layer.shadowOpacity = 0.3
        container.layer.shadowOffset = CGSize(width: 0, height: 3)
        container.layer.masksToBounds = false
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    lazy var titleLabel: UILabel = {
        let title = UILabel()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        title.attributedText = NSAttributedString(string: "",
                                                  attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    lazy var playPauseButton: UIButton = {
        let playPause = UIButton()
        playPause.setImage(UIImage(named: "pause"), for: .normal)
        playPause.addTarget(self, action: #selector(playPauseButtonDidReceiveTouchUpInside), for: .touchUpInside)
        playPause.translatesAutoresizingMaskIntoConstraints = false
        playPause.heightAnchor.constraint(equalToConstant: PopupPlayerView.buttonSize).isActive = true
        playPause.widthAnchor.constraint(equalToConstant: PopupPlayerView.buttonSize).isActive = true
        return playPause
    }()
    
    lazy var stopButton: UIButton = {
        let stop = UIButton()
        stop.setTitle("", for: .normal)
        stop.setImage(UIImage(named: "stop"), for: .normal)
        stop.translatesAutoresizingMaskIntoConstraints = false
        stop.addTarget(self, action: #selector(stopButtonDidReceiveTouchUpInside), for: .touchUpInside)
        stop.translatesAutoresizingMaskIntoConstraints = false
        stop.heightAnchor.constraint(equalToConstant: PopupPlayerView.buttonSize).isActive = true
        stop.widthAnchor.constraint(equalToConstant: PopupPlayerView.buttonSize).isActive = true
        return stop
    }()
    
    lazy var previousSongButton: UIButton = {
        let previousSong = UIButton()
        previousSong.setTitle("", for: .normal)
        previousSong.setImage(UIImage(named: "previous_track"), for: .normal)
        previousSong.addTarget(self, action: #selector(previousSongButtonDidReceiveTouchUpInside), for: .touchUpInside)
        previousSong.translatesAutoresizingMaskIntoConstraints = false
        previousSong.heightAnchor.constraint(equalToConstant: PopupPlayerView.buttonSize).isActive = true
        previousSong.widthAnchor.constraint(equalToConstant: PopupPlayerView.buttonSize).isActive = true
        return previousSong
    }()
    
    lazy var nextSongButton: UIButton = {
        let nextSong = UIButton()
        nextSong.setTitle("", for: .normal)
        nextSong.setImage(UIImage(named: "next_track"), for: .normal)
        nextSong.addTarget(self, action: #selector(nextSongButtonDidReceiveTouchUpInside), for: .touchUpInside)
        nextSong.translatesAutoresizingMaskIntoConstraints = false
        nextSong.heightAnchor.constraint(equalToConstant: PopupPlayerView.buttonSize).isActive = true
        nextSong.widthAnchor.constraint(equalToConstant: PopupPlayerView.buttonSize).isActive = true
        return nextSong
    }()
    
    lazy var buttonsStackView: UIStackView = {
        let buttonsStackView = UIStackView(arrangedSubviews: [stopButton, previousSongButton, playPauseButton, nextSongButton, stopButton])
        buttonsStackView.axis = .horizontal
        buttonsStackView.alignment = .center
        buttonsStackView.distribution = .equalSpacing
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        return buttonsStackView
    }()
    
    lazy var closePlayerButton: UIButton = {
        let close = UIButton()
        close.setTitle("close", for: .normal)
        close.translatesAutoresizingMaskIntoConstraints = false
        close.addTarget(self, action: #selector(closePlayerButtonDidReceiveTouchUpInside), for: .touchUpInside)
        return close
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        backgroundColor = .dark_green
        setupContainerView()
    }
    
    func setupContainerView() {
        addSubview(containerView)
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        containerViewTopConstraint = containerView.topAnchor.constraint(equalTo: topAnchor, constant: -10)
        containerViewTopConstraint?.isActive = true
        containerView.heightAnchor.constraint(greaterThanOrEqualToConstant: PopupPlayerView.minHeight).isActive = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handlePopupPlayerTapGesture(recognizer:)))
        containerView.addGestureRecognizer(tapGestureRecognizer)
        setupTitleLabel()
        setupButtonsContainerView()
    }
    
    @objc func handlePopupPlayerTapGesture(recognizer: UITapGestureRecognizer) {
        if isExpanded {
            containerViewTopConstraint?.constant = -10
            delegate?.reduceToSmallPlayer()
            isExpanded = false
        } else {
            containerViewTopConstraint?.constant = 10
            delegate?.expandToFullPlayer()
            isExpanded = true
        }
    }
    
    func setupTitleLabel() {
        containerView.addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20).isActive = true
        titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20).isActive = true
    }
    
    func setupButtonsContainerView() {
        containerView.addSubview(buttonsStackView)
        buttonsStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
        buttonsStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20).isActive = true
        buttonsStackView.topAnchor.constraint(greaterThanOrEqualTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        buttonsStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20).isActive = true
    }
    
    @objc func playPauseButtonDidReceiveTouchUpInside() {
        delegate?.playPauseButtonDidReceiveTouchUpInside()
    }
    
    @objc func stopButtonDidReceiveTouchUpInside() {
        if isExpanded {
            containerViewTopConstraint?.constant = -10
            isExpanded = false
        }
        delegate?.stopButtonDidReceiveTouchUpInside()
    }
    
    @objc func previousSongButtonDidReceiveTouchUpInside() {
        delegate?.previousSongButtonDidReceiveTouchUpInside()
    }
    
    @objc func nextSongButtonDidReceiveTouchUpInside() {
        delegate?.nextSongButtonDidReceiveTouchUpInside()
    }
    
    @objc func closePlayerButtonDidReceiveTouchUpInside() {
        
    }
    
    func playSong(title: String) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        titleLabel.attributedText = NSAttributedString(string: title,
                                                       attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
    }
    
    func pauseSong() {
        playPauseButton.setImage(UIImage(named: "play"), for: .normal)
    }
    
}
