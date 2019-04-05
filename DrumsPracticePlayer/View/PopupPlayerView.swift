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
    func expandToFullPlayer(animations: (()->())?, completion: (()->())?)
    func reduceToSmallPlayer(animations: (()->())?, completion: (()->())?)
    func previousCheckpointButtonDidReceiveTouchUpInside()
    func nextCheckpointButtonDidReceiveTouchUpInside()
    func repeatButtonDidReceiveTouchUpInside()
    func shuffleButtonDidReceiveTouchUpInside()
    func metronomeButtonDidReceiveTouchUpInside()
    func editButtonDidReceiveTouchUpInside()
}

class PopupPlayerView: UIView {
    
    static let minHeight: CGFloat = 140
    static let maxHeight: CGFloat = 500
    static let buttonSize: CGFloat = 40
    
    var isExpanded = false {
        didSet {
            UIApplication.shared.isIdleTimerDisabled = isExpanded
        }
    }
    var containerViewTopConstraint: NSLayoutConstraint?
    var titleLabelTopConstraint: NSLayoutConstraint?
    var delegate: (PopupPlayerViewDelegate & CheckpointsViewDelegate)?
    var pickerViewDelegate: UIPickerViewDelegate?
    var pickerViewDataSource: UIPickerViewDataSource?
    
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
        return UIButton.roundButton(imageName: "pause", size: PopupPlayerView.buttonSize, target: self, selector: #selector(playPauseButtonDidReceiveTouchUpInside))
    }()
    
    lazy var stopButton: UIButton = {
        return UIButton.roundButton(imageName: "stop", size: PopupPlayerView.buttonSize, target: self, selector: #selector(stopButtonDidReceiveTouchUpInside))
    }()
    
    lazy var previousSongButton: UIButton = {
        return UIButton.roundButton(imageName: "previous_track", size: PopupPlayerView.buttonSize, target: self, selector: #selector(previousSongButtonDidReceiveTouchUpInside))
    }()
    
    lazy var nextSongButton: UIButton = {
        return UIButton.roundButton(imageName: "next_track", size: PopupPlayerView.buttonSize, target: self, selector: #selector(nextSongButtonDidReceiveTouchUpInside))
    }()
    
    lazy var buttonsStackView: UIStackView = {
        let buttonsStackView = UIStackView(arrangedSubviews: [stopButton, previousSongButton, playPauseButton, nextSongButton, stopButton])
        buttonsStackView.axis = .horizontal
        buttonsStackView.alignment = .center
        buttonsStackView.distribution = .equalSpacing
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        return buttonsStackView
    }()
    
    lazy var checkpointsStackView: CheckpointsView = {
        return CheckpointsView(delegate: delegate,
                               pickerViewDelegate: pickerViewDelegate,
                               pickerViewDataSource: pickerViewDataSource)
    }()
    
    lazy var closePlayerButton: UIButton = {
        return UIButton.roundButton(imageName: "close", size: PopupPlayerView.buttonSize, target: self, selector: #selector(closePlayerButtonDidReceiveTouchUpInside))
    }()
    
    lazy var expandedPlayerContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var repeatButton: UIButton = {
        return UIButton.roundButton(imageName: "repeat", size: PopupPlayerView.buttonSize, target: self, selector: #selector(repeatButtonDidReceiveTouchUpInside))
    }()
    
    lazy var shuffleButton: UIButton = {
        return UIButton.roundButton(imageName: "shuffle", size: PopupPlayerView.buttonSize, target: self, selector: #selector(shuffleButtonDidReceiveTouchUpInside))
    }()
    
    lazy var expandedPreviousSongButton: UIButton = {
        return UIButton.roundButton(imageName: "previous_track", size: PopupPlayerView.buttonSize, target: self, selector: #selector(previousSongButtonDidReceiveTouchUpInside))
    }()
    
    lazy var expandedNextSongButton: UIButton = {
        return UIButton.roundButton(imageName: "next_track", size: PopupPlayerView.buttonSize, target: self, selector: #selector(nextSongButtonDidReceiveTouchUpInside))
    }()
    
    lazy var expandedPlayPauseButton: UIButton = {
        return UIButton.roundButton(imageName: "play", size: PopupPlayerView.buttonSize + 20, target: self, selector: #selector(playPauseButtonDidReceiveTouchUpInside))
    }()
    
    lazy var metronomeButton: UIButton = {
        return UIButton.roundButton(imageName: "metronome", size: PopupPlayerView.buttonSize, target: self, selector: #selector(metronomeButtonDidReceiveTouchUpInside))
    }()
    
    lazy var editButton: UIButton = {
        return UIButton.roundButton(imageName: "pencil", size: PopupPlayerView.buttonSize, target: self, selector: #selector(editButtonDidReceiveTouchUpInside))
    }()
    
    lazy var expandedSongButtonsStackView: UIStackView = {
        let buttons = UIStackView(arrangedSubviews: [expandedPreviousSongButton, expandedPlayPauseButton, expandedNextSongButton])
        buttons.axis = .horizontal
        buttons.alignment = .center
        buttons.distribution = .equalSpacing
        buttons.translatesAutoresizingMaskIntoConstraints = false
        return buttons
    }()
    
    lazy var expandedOptionButtonsStackView: UIStackView = {
        let buttons = UIStackView(arrangedSubviews: [shuffleButton, repeatButton])
        buttons.axis = .horizontal
        buttons.alignment = .center
        buttons.distribution = .equalSpacing
        buttons.translatesAutoresizingMaskIntoConstraints = false
        return buttons
    }()
    
    lazy var topSeparatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .dark_green
        return view
    }()
    
    lazy var bottomSeparatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .dark_green
        return view
    }()
    
    lazy var checkpointsContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    convenience init(delegate: (PopupPlayerViewDelegate & CheckpointsViewDelegate)?,
                     pickerViewDelegate: UIPickerViewDelegate?,
                     pickerViewDataSource: UIPickerViewDataSource?) {
        self.init()
        self.delegate = delegate
        self.pickerViewDelegate = pickerViewDelegate
        self.pickerViewDataSource = pickerViewDataSource
        setupView()
    }
    
    func setupView() {
        backgroundColor = .dark_green
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
        setupCloseButton()
        setupRetractedPlayerButtonsStackView()
    }
    
    func setupTitleLabel() {
        containerView.addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20).isActive = true
        titleLabelTopConstraint = titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20)
        titleLabelTopConstraint?.isActive = true
    }
    
    func setupCloseButton() {
        containerView.addSubview(closePlayerButton)
        closePlayerButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20).isActive = true
        closePlayerButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20).isActive = true
        closePlayerButton.isHidden = true
    }
    
    func setupRetractedPlayerButtonsStackView() {
        containerView.addSubview(buttonsStackView)
        buttonsStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
        buttonsStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20).isActive = true
        buttonsStackView.topAnchor.constraint(greaterThanOrEqualTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        buttonsStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20).isActive = true
        buttonsStackView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupExpandedPlayerContainerView() {
        containerView.addSubview(expandedPlayerContainerView)
        expandedPlayerContainerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
        expandedPlayerContainerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20).isActive = true
        expandedPlayerContainerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20).isActive = true
        expandedPlayerContainerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50).isActive = true
        
        expandedPlayerContainerView.addSubview(topSeparatorView)
        topSeparatorView.topAnchor.constraint(equalTo: closePlayerButton.bottomAnchor, constant: 20).isActive = true
        topSeparatorView.widthAnchor.constraint(equalTo: expandedPlayerContainerView.widthAnchor).isActive = true
        topSeparatorView.centerXAnchor.constraint(equalTo: expandedPlayerContainerView.centerXAnchor).isActive = true
        topSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        setupCheckpointContainerView()
        
        expandedPlayerContainerView.addSubview(bottomSeparatorView)
        bottomSeparatorView.topAnchor.constraint(equalTo: checkpointsContainerView.bottomAnchor).isActive = true
        bottomSeparatorView.widthAnchor.constraint(equalTo: expandedPlayerContainerView.widthAnchor).isActive = true
        bottomSeparatorView.centerXAnchor.constraint(equalTo: expandedPlayerContainerView.centerXAnchor).isActive = true
        bottomSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        expandedPlayerContainerView.addSubview(metronomeButton)
        metronomeButton.bottomAnchor.constraint(equalTo: bottomSeparatorView.topAnchor, constant: -20).isActive = true
        metronomeButton.trailingAnchor.constraint(equalTo: expandedPlayerContainerView.trailingAnchor, constant: 0).isActive = true
        
        expandedPlayerContainerView.addSubview(editButton)
        editButton.leadingAnchor.constraint(equalTo: expandedPlayerContainerView.leadingAnchor, constant: 0).isActive = true
        editButton.bottomAnchor.constraint(equalTo: bottomSeparatorView.topAnchor, constant: -20).isActive = true
        
        setupExpandedPlayerButtonsContainerView()
    }
    
    func setupCheckpointContainerView() {
        expandedPlayerContainerView.addSubview(checkpointsContainerView)
        checkpointsContainerView.widthAnchor.constraint(equalTo: expandedPlayerContainerView.widthAnchor).isActive = true
        checkpointsContainerView.centerXAnchor.constraint(equalTo: expandedPlayerContainerView.centerXAnchor).isActive = true
        checkpointsContainerView.topAnchor.constraint(equalTo: topSeparatorView.bottomAnchor).isActive = true
        
        checkpointsContainerView.addSubview(checkpointsStackView)
        checkpointsStackView.centerXAnchor.constraint(equalTo: checkpointsContainerView.centerXAnchor).isActive = true
        checkpointsStackView.centerYAnchor.constraint(equalTo: checkpointsContainerView.centerYAnchor).isActive = true
        checkpointsStackView.widthAnchor.constraint(equalTo: checkpointsContainerView.widthAnchor, constant: -40).isActive = true
        checkpointsStackView.heightAnchor.constraint(lessThanOrEqualTo: checkpointsContainerView.heightAnchor, constant: -40).isActive = true
    }
    
    func setupExpandedPlayerButtonsContainerView() {
        let buttonsContainer = UIView()
        buttonsContainer.translatesAutoresizingMaskIntoConstraints = false
        expandedPlayerContainerView.addSubview(buttonsContainer)
        buttonsContainer.centerXAnchor.constraint(equalTo: expandedPlayerContainerView.centerXAnchor).isActive = true
        buttonsContainer.widthAnchor.constraint(equalTo: expandedPlayerContainerView.widthAnchor).isActive = true
        buttonsContainer.bottomAnchor.constraint(equalTo: expandedPlayerContainerView.bottomAnchor).isActive = true
        buttonsContainer.topAnchor.constraint(equalTo: bottomSeparatorView.bottomAnchor, constant: 50).isActive = true
        
        buttonsContainer.addSubview(expandedSongButtonsStackView)
        expandedSongButtonsStackView.leadingAnchor.constraint(equalTo: buttonsContainer.leadingAnchor).isActive = true
        expandedSongButtonsStackView.trailingAnchor.constraint(equalTo: buttonsContainer.trailingAnchor).isActive = true
        expandedSongButtonsStackView.topAnchor.constraint(equalTo: buttonsContainer.topAnchor).isActive = true
        expandedSongButtonsStackView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        buttonsContainer.addSubview(expandedOptionButtonsStackView)
        expandedOptionButtonsStackView.leadingAnchor.constraint(equalTo: buttonsContainer.leadingAnchor, constant: 75).isActive = true
        expandedOptionButtonsStackView.trailingAnchor.constraint(equalTo: buttonsContainer.trailingAnchor, constant: -75).isActive = true
        expandedOptionButtonsStackView.bottomAnchor.constraint(equalTo: buttonsContainer.bottomAnchor).isActive = true
        expandedOptionButtonsStackView.topAnchor.constraint(equalTo: expandedSongButtonsStackView.bottomAnchor, constant: 20).isActive = true
        expandedOptionButtonsStackView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        buttonsContainer.heightAnchor.constraint(equalToConstant: 140).isActive = true
    }
    
    @objc func playPauseButtonDidReceiveTouchUpInside() {
        delegate?.playPauseButtonDidReceiveTouchUpInside()
    }
    
    @objc func stopButtonDidReceiveTouchUpInside() {
        delegate?.stopButtonDidReceiveTouchUpInside()
    }
    
    @objc func previousSongButtonDidReceiveTouchUpInside() {
        delegate?.previousSongButtonDidReceiveTouchUpInside()
    }
    
    @objc func nextSongButtonDidReceiveTouchUpInside() {
        delegate?.nextSongButtonDidReceiveTouchUpInside()
    }
    
    @objc func closePlayerButtonDidReceiveTouchUpInside() {
        if isExpanded {
            retractAndHidePlayer()
        }
    }
    
    @objc func repeatButtonDidReceiveTouchUpInside() {
        delegate?.repeatButtonDidReceiveTouchUpInside()
    }
    
    @objc func shuffleButtonDidReceiveTouchUpInside() {
        delegate?.shuffleButtonDidReceiveTouchUpInside()
    }
    
    @objc func metronomeButtonDidReceiveTouchUpInside() {
        delegate?.metronomeButtonDidReceiveTouchUpInside()
    }
    
    @objc func editButtonDidReceiveTouchUpInside() {
        delegate?.editButtonDidReceiveTouchUpInside()
    }
    
    func playSong(title: String, hasCheckpoints: Bool) {
        titleLabel.attributedText = NSAttributedString(string: title)
        isExpanded ? expandTitleLabel() : retractTitleLabel()
        playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
        expandedPlayPauseButton.setImage(UIImage(named: "pause"), for: .normal)
        checkpointsContainerView.isHidden = !hasCheckpoints
        checkpointsStackView.reloadCheckpoints()
    }
    
    func pauseSong() {
        playPauseButton.setImage(UIImage(named: "play"), for: .normal)
        expandedPlayPauseButton.setImage(UIImage(named: "play"), for: .normal)
    }
    
    func stopPlayer() {
        isExpanded ? closePlayerButtonDidReceiveTouchUpInside() : stopButtonDidReceiveTouchUpInside()
    }
    
    func expandTitleLabel() {
        let title = titleLabel.attributedText?.string ?? ""
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let font = UIFont.systemFont(ofSize: 18.0, weight: .semibold)
        titleLabel.attributedText = NSAttributedString(string: title,
                                                       attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle,
                                                                    NSAttributedString.Key.font: font])
    }
    
    func retractTitleLabel() {
        let title = titleLabel.attributedText?.string ?? ""
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        titleLabel.attributedText = NSAttributedString(string: title,
                                                       attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
    }
    
    func retractPlayer() {
        self.containerViewTopConstraint?.constant = -10
        self.titleLabelTopConstraint?.constant = 20
        self.expandedPlayerContainerView.removeFromSuperview()
        self.delegate?.reduceToSmallPlayer(animations: {
            self.closePlayerButton.alpha = 0.0
            self.expandedPlayerContainerView.alpha = 0.0
            self.buttonsStackView.alpha = 1.0
            self.retractTitleLabel()
        }, completion: nil)
        self.isExpanded = false
        self.closePlayerButton.isHidden = true
        self.buttonsStackView.isHidden = false
    }
    
    func retractAndHidePlayer() {
        self.containerViewTopConstraint?.constant = -10
        self.titleLabelTopConstraint?.constant = 20
        self.expandedPlayerContainerView.removeFromSuperview()
        self.delegate?.reduceToSmallPlayer(animations: {
            self.closePlayerButton.alpha = 0.0
            self.expandedPlayerContainerView.alpha = 0.0
            self.buttonsStackView.alpha = 1.0
            self.retractTitleLabel()
        }, completion: {
            self.delegate?.stopButtonDidReceiveTouchUpInside()
        })
        self.isExpanded = false
        self.closePlayerButton.isHidden = true
        self.buttonsStackView.isHidden = false
    }
    
    
    @objc func handlePopupPlayerTapGesture(recognizer: UITapGestureRecognizer) {
        if isExpanded {
            retractPlayer()
        } else {
            self.titleLabelTopConstraint?.constant = 30
            self.containerViewTopConstraint?.constant = 10
            self.expandedPlayerContainerView.alpha = 0.0
            self.delegate?.expandToFullPlayer(animations: {
                self.closePlayerButton.alpha = 1.0
                self.buttonsStackView.alpha = 0.0
                self.expandTitleLabel()
            }, completion: {
                self.expandedPlayerContainerView.alpha = 1.0
            })
            self.setupExpandedPlayerContainerView()
            self.closePlayerButton.isHidden = false
            self.buttonsStackView.isHidden = true
            self.isExpanded = true
        }
    }
}
