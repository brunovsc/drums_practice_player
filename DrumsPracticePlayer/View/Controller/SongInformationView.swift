//
//  SongInformationView.swift
//  DrumsPracticePlayer
//
//  Created by Bruno Vieira on 03/04/19.
//  Copyright © 2019 Bruno Vieira. All rights reserved.
//

import UIKit

protocol SongInformationViewDelegate {
    func saveButtonDidReceiveTouchUpInside()
    func cancelButtonDidReceiveTouchUpInside()
    func markCheckpointButtonDidReceiveTouchUpInside()
    func editCheckpointsButtonDidReceiveTouchUpInside()
    
    func lessLowerTimeSignatureButtonDidReceiveTouchUpInside()
    func moreLowerTimeSignatureButtonDidReceiveTouchUpInside()
    func lessUpperTimeSignatureButtonDidReceiveTouchUpInside()
    func moreUpperTimeSignatureButtonDidReceiveTouchUpInside()
}

class SongInformationView: UIView {
    
    static let buttonSize: CGFloat = 32
    var delegate: SongInformationViewDelegate?
    var textFieldDelegate: UITextFieldDelegate?
    var tableViewDelegate: UITableViewDelegate?
    var tableViewDataSource: UITableViewDataSource?

    lazy var songHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "Track Info"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var songTitleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Title"
        textField.delegate = self.textFieldDelegate
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var songArtistTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Artist"
        textField.delegate = self.textFieldDelegate
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var metronomeContainerSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .dark_green
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }()
    
    lazy var tempoLabel: UILabel = {
        let label = UILabel()
        label.text = "Tempo:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    lazy var tempoTextField: UITextField = {
        let textField = UITextField()
        textField.text = "120"
        textField.returnKeyType = .done
        textField.keyboardType = .numberPad
        textField.delegate = textFieldDelegate
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var tempoBpmLabel: UILabel = {
        let label = UILabel()
        label.text = "bpm"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var tempoSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 60.0
        slider.maximumValue = 180.0
        slider.thumbTintColor = .gray
        slider.maximumTrackTintColor = .dark_green
        slider.minimumTrackTintColor = .dark_green
        slider.isContinuous = false
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    lazy var timeSignatureTitleLabel: UILabel = {
        let label = UILabel()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        label.attributedText = NSAttributedString(string: "Time signature",
                                                  attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var timeSignatureUpperLabel: UILabel = {
        let label = UILabel()
        label.text = "4"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var timeSignatureLowerLabel: UILabel = {
        let label = UILabel()
        label.text = "4"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var lessLowerTimeSignatureButton: UIButton = {
        return UIButton.roundButton(imageName: "minus", size: MetronomeView.buttonSize, target: self, selector: #selector(lessLowerTimeSignatureButtonDidReceiveTouchUpInside))
    }()
    
    lazy var moreLowerTimeSignatureButton: UIButton = {
        return UIButton.roundButton(imageName: "plus", size: MetronomeView.buttonSize, target: self, selector: #selector(moreLowerTimeSignatureButtonDidReceiveTouchUpInside))
    }()
    
    lazy var lessUpperTimeSignatureButton: UIButton = {
        return UIButton.roundButton(imageName: "minus", size: MetronomeView.buttonSize, target: self, selector: #selector(lessUpperTimeSignatureButtonDidReceiveTouchUpInside))
    }()
    
    lazy var moreUpperTimeSignatureButton: UIButton = {
        return UIButton.roundButton(imageName: "plus", size: MetronomeView.buttonSize, target: self, selector: #selector(moreUpperTimeSignatureButtonDidReceiveTouchUpInside))
    }()
    
    lazy var checkpointsLabel: UILabel = {
        let label = UILabel()
        label.text = "Checkpoints"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var minTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "0:00"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var maxTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "3:54"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var timeSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 360
        slider.thumbTintColor = .gray
        slider.maximumTrackTintColor = .dark_green
        slider.minimumTrackTintColor = .dark_green
        slider.isContinuous = true
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    lazy var checkpointsTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self.tableViewDelegate
        tableView.dataSource = self.tableViewDataSource
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("SAVE", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .green
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        return button
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("CANCEL", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .red
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        return button
    }()
    
    lazy var markCheckpointButton: UIButton = {
        let button = UIButton()
        button.setTitle("MARK", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var removeCheckpointsButton: UIButton = {
        let button = UIButton()
        button.setTitle("REMOVE", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var songInfoContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .light_green
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var tempoContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .light_green
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var checkpointsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .light_green
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var buttonsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    convenience init(delegate: SongInformationViewDelegate?,
                     textFieldDelegate: UITextFieldDelegate?,
                     tableViewDelegate: UITableViewDelegate?,
                     tableViewDataSource: UITableViewDataSource?) {
        self.init()
        self.delegate = delegate
        self.textFieldDelegate = textFieldDelegate
        self.tableViewDelegate = tableViewDelegate
        self.tableViewDataSource = tableViewDataSource
        setupView()
    }
    
    
    func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(songInfoContainerView)
        songInfoContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        songInfoContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        songInfoContainerView.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        setupSongInfoContainerView()
        
        addSubview(tempoContainerView)
        tempoContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        tempoContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        tempoContainerView.topAnchor.constraint(equalTo: songInfoContainerView.bottomAnchor, constant: 10).isActive = true
        setupTempoContainerView()
        
        addSubview(checkpointsContainerView)
        checkpointsContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        checkpointsContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        checkpointsContainerView.topAnchor.constraint(equalTo: tempoContainerView.bottomAnchor, constant: 10).isActive = true
        setupCheckpointsContainerView()
        
        addSubview(buttonsContainerView)
        buttonsContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        buttonsContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        buttonsContainerView.topAnchor.constraint(equalTo: checkpointsContainerView.bottomAnchor, constant: 10).isActive = true
        buttonsContainerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        setupButtonsContainerView()
    }
    
    func setupSongInfoContainerView() {
        songInfoContainerView.addSubview(songHeaderLabel)
        songHeaderLabel.centerXAnchor.constraint(equalTo: songInfoContainerView.centerXAnchor).isActive = true
        songHeaderLabel.topAnchor.constraint(equalTo: songInfoContainerView.topAnchor, constant: 20).isActive = true
        
        songInfoContainerView.addSubview(songTitleTextField)
        songTitleTextField.leadingAnchor.constraint(equalTo: songInfoContainerView.leadingAnchor, constant: 20).isActive = true
        songTitleTextField.trailingAnchor.constraint(equalTo: songInfoContainerView.trailingAnchor, constant: -20).isActive = true
        songTitleTextField.topAnchor.constraint(equalTo: songHeaderLabel.bottomAnchor, constant: 20).isActive = true
        
        songInfoContainerView.addSubview(songArtistTextField)
        songArtistTextField.leadingAnchor.constraint(equalTo: songInfoContainerView.leadingAnchor, constant: 20).isActive = true
        songArtistTextField.trailingAnchor.constraint(equalTo: songInfoContainerView.trailingAnchor, constant: -20).isActive = true
        songArtistTextField.bottomAnchor.constraint(equalTo: songInfoContainerView.bottomAnchor, constant: -20).isActive = true
        songArtistTextField.topAnchor.constraint(equalTo: songTitleTextField.bottomAnchor, constant: 20).isActive = true
    }
    
    func setupTempoContainerView() {        
        tempoContainerView.addSubview(tempoLabel)
        tempoLabel.leadingAnchor.constraint(equalTo: tempoContainerView.leadingAnchor, constant: 20).isActive = true
        tempoLabel.topAnchor.constraint(equalTo: tempoContainerView.topAnchor, constant: 20).isActive = true
        tempoLabel.setContentHuggingPriority(UILayoutPriority(1000), for: .horizontal)
        
        tempoContainerView.addSubview(tempoTextField)
        tempoTextField.leadingAnchor.constraint(equalTo: tempoLabel.trailingAnchor, constant: 10).isActive = true
        tempoTextField.centerYAnchor.constraint(equalTo: tempoLabel.centerYAnchor).isActive = true
        tempoTextField.setContentHuggingPriority(UILayoutPriority(750), for: .horizontal)
        
        tempoContainerView.addSubview(tempoBpmLabel)
        tempoBpmLabel.leadingAnchor.constraint(equalTo: tempoTextField.trailingAnchor, constant: 5).isActive = true
        tempoBpmLabel.centerYAnchor.constraint(equalTo: tempoTextField.centerYAnchor).isActive = true
        tempoBpmLabel.setContentHuggingPriority(UILayoutPriority(1000), for: .horizontal)
        
        tempoContainerView.addSubview(tempoSlider)
        tempoSlider.leadingAnchor.constraint(equalTo: tempoBpmLabel.trailingAnchor, constant: 20).isActive = true
        tempoSlider.trailingAnchor.constraint(equalTo: tempoContainerView.trailingAnchor, constant: -20).isActive = true
        tempoSlider.centerYAnchor.constraint(equalTo: tempoBpmLabel.centerYAnchor).isActive = true
        
        tempoContainerView.addSubview(metronomeContainerSeparatorView)
        metronomeContainerSeparatorView.topAnchor.constraint(equalTo: tempoLabel.bottomAnchor, constant: 20).isActive = true
        metronomeContainerSeparatorView.leadingAnchor.constraint(equalTo: tempoContainerView.leadingAnchor, constant: 20).isActive = true
        metronomeContainerSeparatorView.trailingAnchor.constraint(equalTo: tempoContainerView.trailingAnchor, constant: -20).isActive = true
        
        tempoContainerView.addSubview(timeSignatureTitleLabel)
        timeSignatureTitleLabel.topAnchor.constraint(equalTo: metronomeContainerSeparatorView.bottomAnchor, constant: 20).isActive = true
        timeSignatureTitleLabel.leadingAnchor.constraint(equalTo: tempoContainerView.leadingAnchor, constant: 20).isActive = true
        timeSignatureTitleLabel.trailingAnchor.constraint(equalTo: tempoContainerView.trailingAnchor, constant: -20).isActive = true
        timeSignatureTitleLabel.centerXAnchor.constraint(equalTo: tempoContainerView.centerXAnchor).isActive = true
        
        tempoContainerView.addSubview(timeSignatureUpperLabel)
        timeSignatureUpperLabel.topAnchor.constraint(equalTo: timeSignatureTitleLabel.bottomAnchor, constant: 30).isActive = true
        timeSignatureUpperLabel.centerXAnchor.constraint(equalTo: tempoContainerView.centerXAnchor).isActive = true
        
        tempoContainerView.addSubview(lessUpperTimeSignatureButton)
        lessUpperTimeSignatureButton.trailingAnchor.constraint(equalTo: timeSignatureUpperLabel.leadingAnchor, constant: -20).isActive = true
        lessUpperTimeSignatureButton.centerYAnchor.constraint(equalTo: timeSignatureUpperLabel.centerYAnchor).isActive = true
        
        tempoContainerView.addSubview(moreUpperTimeSignatureButton)
        moreUpperTimeSignatureButton.leadingAnchor.constraint(equalTo: timeSignatureUpperLabel.trailingAnchor, constant: 20).isActive = true
        moreUpperTimeSignatureButton.centerYAnchor.constraint(equalTo: timeSignatureUpperLabel.centerYAnchor).isActive = true
        
        tempoContainerView.addSubview(timeSignatureLowerLabel)
        timeSignatureLowerLabel.topAnchor.constraint(equalTo: timeSignatureUpperLabel.bottomAnchor, constant: 40).isActive = true
        timeSignatureLowerLabel.centerXAnchor.constraint(equalTo: tempoContainerView.centerXAnchor).isActive = true
        
        tempoContainerView.addSubview(lessLowerTimeSignatureButton)
        lessLowerTimeSignatureButton.trailingAnchor.constraint(equalTo: timeSignatureLowerLabel.leadingAnchor, constant: -20).isActive = true
        lessLowerTimeSignatureButton.centerYAnchor.constraint(equalTo: timeSignatureLowerLabel.centerYAnchor).isActive = true
        
        tempoContainerView.addSubview(moreLowerTimeSignatureButton)
        moreLowerTimeSignatureButton.leadingAnchor.constraint(equalTo: timeSignatureLowerLabel.trailingAnchor, constant: 20).isActive = true
        moreLowerTimeSignatureButton.centerYAnchor.constraint(equalTo: timeSignatureLowerLabel.centerYAnchor).isActive = true
        moreLowerTimeSignatureButton.bottomAnchor.constraint(equalTo: tempoContainerView.bottomAnchor, constant: -20).isActive = true
    }
    
    func setupCheckpointsContainerView() {
        checkpointsContainerView.addSubview(checkpointsLabel)
        checkpointsLabel.centerXAnchor.constraint(equalTo: checkpointsContainerView.centerXAnchor).isActive = true
        checkpointsLabel.topAnchor.constraint(equalTo: checkpointsContainerView.topAnchor, constant: 20).isActive = true
        
        checkpointsContainerView.addSubview(minTimeLabel)
        minTimeLabel.leadingAnchor.constraint(equalTo: checkpointsContainerView.leadingAnchor, constant: 20).isActive = true
        minTimeLabel.topAnchor.constraint(equalTo: checkpointsLabel.bottomAnchor, constant: 20).isActive = true
        
        checkpointsContainerView.addSubview(timeSlider)
        timeSlider.leadingAnchor.constraint(equalTo: minTimeLabel.trailingAnchor, constant: 10).isActive = true
        timeSlider.centerYAnchor.constraint(equalTo: minTimeLabel.centerYAnchor).isActive = true
        
        checkpointsContainerView.addSubview(maxTimeLabel)
        maxTimeLabel.leadingAnchor.constraint(equalTo: timeSlider.trailingAnchor, constant: 10).isActive = true
        maxTimeLabel.centerYAnchor.constraint(equalTo: timeSlider.centerYAnchor).isActive = true
        maxTimeLabel.trailingAnchor.constraint(equalTo: checkpointsContainerView.trailingAnchor, constant: -20).isActive = true
        
        
//        checkpointsContainerView.addSubview(checkpointsTableView)
    }
    
    func setupButtonsContainerView() {
        buttonsContainerView.addSubview(cancelButton)
        cancelButton.leadingAnchor.constraint(equalTo: buttonsContainerView.leadingAnchor).isActive = true
        cancelButton.topAnchor.constraint(equalTo: buttonsContainerView.topAnchor).isActive = true
        cancelButton.bottomAnchor.constraint(equalTo: buttonsContainerView.bottomAnchor).isActive = true
        
        buttonsContainerView.addSubview(saveButton)
        saveButton.widthAnchor.constraint(equalTo: cancelButton.widthAnchor).isActive = true
        saveButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: 10).isActive = true
        saveButton.centerYAnchor.constraint(equalTo: cancelButton.centerYAnchor).isActive = true
        saveButton.trailingAnchor.constraint(equalTo: buttonsContainerView.trailingAnchor).isActive = true
    }
    
    @objc func lessLowerTimeSignatureButtonDidReceiveTouchUpInside() {
        delegate?.lessLowerTimeSignatureButtonDidReceiveTouchUpInside()
    }
    
    @objc func moreLowerTimeSignatureButtonDidReceiveTouchUpInside() {
        delegate?.moreLowerTimeSignatureButtonDidReceiveTouchUpInside()
    }
    
    @objc func lessUpperTimeSignatureButtonDidReceiveTouchUpInside() {
        delegate?.lessUpperTimeSignatureButtonDidReceiveTouchUpInside()
    }
    
    @objc func moreUpperTimeSignatureButtonDidReceiveTouchUpInside() {
        delegate?.moreUpperTimeSignatureButtonDidReceiveTouchUpInside()
    }
}
