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
    var delegate: PopupPlayerViewDelegate?
    var pickerViewDelegate: UIPickerViewDelegate? {
        didSet {
            checkpointPickerView.delegate = pickerViewDelegate
        }
    }
    var pickerViewDataSource: UIPickerViewDataSource? {
        didSet {
            checkpointPickerView.dataSource = pickerViewDataSource
        }
    }
    
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
    
    lazy var previousCheckpointButton: UIButton = {
        let previousCheckpoint = UIButton()
        previousCheckpoint.setTitle("", for: .normal)
        previousCheckpoint.setImage(UIImage(named: "top"), for: .normal)
        previousCheckpoint.addTarget(self, action: #selector(previousCheckpointButtonDidReceiveTouchUpInside), for: .touchUpInside)
        previousCheckpoint.translatesAutoresizingMaskIntoConstraints = false
        previousCheckpoint.heightAnchor.constraint(equalToConstant: PopupPlayerView.buttonSize).isActive = true
        previousCheckpoint.widthAnchor.constraint(equalToConstant: PopupPlayerView.buttonSize).isActive = true
        return previousCheckpoint
    }()
    
    lazy var nextCheckpointButton: UIButton = {
        let nextCheckpoint = UIButton()
        nextCheckpoint.setTitle("", for: .normal)
        nextCheckpoint.setImage(UIImage(named: "bottom"), for: .normal)
        nextCheckpoint.addTarget(self, action: #selector(nextCheckpointButtonDidReceiveTouchUpInside), for: .touchUpInside)
        nextCheckpoint.translatesAutoresizingMaskIntoConstraints = false
        nextCheckpoint.heightAnchor.constraint(equalToConstant: PopupPlayerView.buttonSize).isActive = true
        nextCheckpoint.widthAnchor.constraint(equalToConstant: PopupPlayerView.buttonSize).isActive = true
        return nextCheckpoint
    }()
    
    lazy var checkpointLabel: UILabel = {
        let checkpoint = UILabel()
        checkpoint.text = "Checkpoint"
        checkpoint.translatesAutoresizingMaskIntoConstraints = false
        return checkpoint
    }()
    
    lazy var checkpointsStackView: UIStackView = {
        let checkpoint = UIStackView(arrangedSubviews: [previousCheckpointButton, checkpointPickerView, nextCheckpointButton])
        checkpoint.axis = .vertical
        checkpoint.alignment = .center
        checkpoint.distribution = .equalSpacing
        checkpoint.spacing = 20.0
        checkpoint.translatesAutoresizingMaskIntoConstraints = false
        return checkpoint
    }()
    
    lazy var closePlayerButton: UIButton = {
        let close = UIButton()
        close.setTitle("", for: .normal)
        close.setImage(UIImage(named: "close"), for: .normal)
        close.translatesAutoresizingMaskIntoConstraints = false
        close.addTarget(self, action: #selector(closePlayerButtonDidReceiveTouchUpInside), for: .touchUpInside)
        close.heightAnchor.constraint(equalToConstant: PopupPlayerView.buttonSize).isActive = true
        close.widthAnchor.constraint(equalToConstant: PopupPlayerView.buttonSize).isActive = true
        return close
    }()
    
    lazy var expandedPlayerContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var repeatButton: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.setImage(UIImage(named: "repeat"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(repeatButtonDidReceiveTouchUpInside), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: PopupPlayerView.buttonSize).isActive = true
        button.widthAnchor.constraint(equalToConstant: PopupPlayerView.buttonSize).isActive = true
        return button
    }()
    
    lazy var shuffleButton: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.setImage(UIImage(named: "shuffle"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(shuffleButtonDidReceiveTouchUpInside), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: PopupPlayerView.buttonSize).isActive = true
        button.widthAnchor.constraint(equalToConstant: PopupPlayerView.buttonSize).isActive = true
        return button
    }()
    
    lazy var expandedPreviousSongButton: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.setImage(UIImage(named: "previous_track"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(previousSongButtonDidReceiveTouchUpInside), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: PopupPlayerView.buttonSize).isActive = true
        button.widthAnchor.constraint(equalToConstant: PopupPlayerView.buttonSize).isActive = true
        return button
    }()
    
    lazy var expandedNextSongButton: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.setImage(UIImage(named: "next_track"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(nextSongButtonDidReceiveTouchUpInside), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: PopupPlayerView.buttonSize).isActive = true
        button.widthAnchor.constraint(equalToConstant: PopupPlayerView.buttonSize).isActive = true
        return button
    }()
    
    lazy var expandedPlayPauseButton: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.setImage(UIImage(named: "play"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(playPauseButtonDidReceiveTouchUpInside), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: PopupPlayerView.buttonSize + 20).isActive = true
        button.widthAnchor.constraint(equalToConstant: PopupPlayerView.buttonSize + 20).isActive = true
        return button
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
    
    var checkpointPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.showsSelectionIndicator = false
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        return pickerView
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
        setupPlayerView()
    }
    
    func setupPlayerView() {
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
    
    @objc func previousCheckpointButtonDidReceiveTouchUpInside() {
        if checkpointPickerView.selectedRow(inComponent: 0) - 1 >= 0 {
            checkpointPickerView.selectRow(checkpointPickerView.selectedRow(inComponent: 0) - 1, inComponent: 0, animated: true)
            delegate?.previousCheckpointButtonDidReceiveTouchUpInside()
        }
    }
    
    @objc func nextCheckpointButtonDidReceiveTouchUpInside() {
        if checkpointPickerView.selectedRow(inComponent: 0) + 1 < checkpointPickerView.numberOfRows(inComponent: 0) {
            checkpointPickerView.selectRow(checkpointPickerView.selectedRow(inComponent: 0) + 1, inComponent: 0, animated: true)
            delegate?.nextCheckpointButtonDidReceiveTouchUpInside()
        }
    }
    
    @objc func repeatButtonDidReceiveTouchUpInside() {
        delegate?.repeatButtonDidReceiveTouchUpInside()
    }
    
    @objc func shuffleButtonDidReceiveTouchUpInside() {
        delegate?.shuffleButtonDidReceiveTouchUpInside()
    }
    
    func playSong(title: String) {
        titleLabel.attributedText = NSAttributedString(string: title)
        isExpanded ? expandTitleLabel() : retractTitleLabel()
        playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
        expandedPlayPauseButton.setImage(UIImage(named: "pause"), for: .normal)
        checkpointPickerView.reloadAllComponents()
        if let numberOfCheckpoints = pickerViewDataSource?.pickerView(checkpointPickerView, numberOfRowsInComponent: 0) {
            checkpointsContainerView.isHidden = numberOfCheckpoints == 0
        } else {
            checkpointsContainerView.isHidden = true
        }
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
