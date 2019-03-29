//
//  MetronomeView.swift
//  DrumsPracticePlayer
//
//  Created by Bruno Vieira on 27/03/19.
//  Copyright © 2019 Bruno Vieira. All rights reserved.
//

import UIKit

protocol MetronomeViewDelegate {
    func turnMetronomeOn()
    func turnMetronomeOff()
    func lessLowerTimeSignatureButtonDidReceiveTouchUpInside()
    func moreLowerTimeSignatureButtonDidReceiveTouchUpInside()
    func lessUpperTimeSignatureButtonDidReceiveTouchUpInside()
    func moreUpperTimeSignatureButtonDidReceiveTouchUpInside()
}

class MetronomeView: UIView {
    
    static let buttonSize: CGFloat = 32
    
    var delegate: (MetronomeViewDelegate & CheckpointsViewDelegate)?
    var textFieldDelegate: UITextFieldDelegate?
    var pickerViewDelegate: UIPickerViewDelegate?
    var pickerViewDataSource: UIPickerViewDataSource?
    
    lazy var metronomeContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .light_green
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var metronomeContainerSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .dark_green
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }()
    
    lazy var checkpointsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .light_green
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
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
    
    lazy var metronomeToggle: UISwitch = {
        let buttonSwitch = UISwitch()
        buttonSwitch.tintColor = .gray
        buttonSwitch.onTintColor = .green
        buttonSwitch.thumbTintColor = .gray
        buttonSwitch.addTarget(self, action: #selector(metronomeToggleValueChanged), for: .valueChanged)
        buttonSwitch.translatesAutoresizingMaskIntoConstraints = false
        return buttonSwitch
        
    }()
    
    lazy var songTitleLabel: UILabel = {
        let label = UILabel()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        label.attributedText = NSAttributedString(string: "SONG NAME",
                                                  attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var checkpointsView: CheckpointsView = {
        let checkpoints = CheckpointsView(delegate: delegate,
                                          pickerViewDelegate: pickerViewDelegate,
                                          pickerViewDataSource: pickerViewDataSource)
        return checkpoints
    }()
    
    convenience init(delegate: (MetronomeViewDelegate & CheckpointsViewDelegate)?,
                     textFieldDelegate: UITextFieldDelegate,
                     pickerViewDelegate: UIPickerViewDelegate?,
                     pickerViewDataSource: UIPickerViewDataSource?) {
        self.init()
        self.delegate = delegate
        self.textFieldDelegate = textFieldDelegate
        self.pickerViewDelegate = pickerViewDelegate
        self.pickerViewDataSource = pickerViewDataSource
        setupView()
    }
    
    
    func setupView() {
        backgroundColor = .dark_green
        translatesAutoresizingMaskIntoConstraints = false
        setupMetronomeContainerView()
        setupCheckpointsContainerView()
    }
    
    func setupMetronomeContainerView() {
        addSubview(metronomeContainerView)
        metronomeContainerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        metronomeContainerView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        metronomeContainerView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        metronomeContainerView.bottomAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true

        metronomeContainerView.addSubview(tempoLabel)
        tempoLabel.leadingAnchor.constraint(equalTo: metronomeContainerView.leadingAnchor, constant: 20).isActive = true
        tempoLabel.topAnchor.constraint(equalTo: metronomeContainerView.topAnchor, constant: 20).isActive = true
        tempoLabel.setContentHuggingPriority(UILayoutPriority(1000), for: .horizontal)
        
        metronomeContainerView.addSubview(tempoTextField)
        tempoTextField.leadingAnchor.constraint(equalTo: tempoLabel.trailingAnchor, constant: 10).isActive = true
        tempoTextField.centerYAnchor.constraint(equalTo: tempoLabel.centerYAnchor).isActive = true
        tempoTextField.setContentHuggingPriority(UILayoutPriority(750), for: .horizontal)
        
        metronomeContainerView.addSubview(tempoBpmLabel)
        tempoBpmLabel.leadingAnchor.constraint(equalTo: tempoTextField.trailingAnchor, constant: 5).isActive = true
        tempoBpmLabel.centerYAnchor.constraint(equalTo: tempoTextField.centerYAnchor).isActive = true
        tempoBpmLabel.setContentHuggingPriority(UILayoutPriority(1000), for: .horizontal)
        
        metronomeContainerView.addSubview(tempoSlider)
        tempoSlider.leadingAnchor.constraint(equalTo: tempoBpmLabel.trailingAnchor, constant: 20).isActive = true
        tempoSlider.trailingAnchor.constraint(equalTo: metronomeContainerView.trailingAnchor, constant: -20).isActive = true
        tempoSlider.centerYAnchor.constraint(equalTo: tempoBpmLabel.centerYAnchor).isActive = true
        
        metronomeContainerView.addSubview(metronomeContainerSeparatorView)
        metronomeContainerSeparatorView.topAnchor.constraint(equalTo: tempoLabel.bottomAnchor, constant: 20).isActive = true
        metronomeContainerSeparatorView.leadingAnchor.constraint(equalTo: metronomeContainerView.leadingAnchor, constant: 20).isActive = true
        metronomeContainerSeparatorView.trailingAnchor.constraint(equalTo: metronomeContainerView.trailingAnchor, constant: -20).isActive = true
        
        metronomeContainerView.addSubview(timeSignatureTitleLabel)
        timeSignatureTitleLabel.topAnchor.constraint(equalTo: metronomeContainerSeparatorView.bottomAnchor, constant: 20).isActive = true
        timeSignatureTitleLabel.leadingAnchor.constraint(equalTo: metronomeContainerView.leadingAnchor, constant: 20).isActive = true
        timeSignatureTitleLabel.trailingAnchor.constraint(equalTo: metronomeContainerView.trailingAnchor, constant: -20).isActive = true
        timeSignatureTitleLabel.centerXAnchor.constraint(equalTo: metronomeContainerView.centerXAnchor).isActive = true

        metronomeContainerView.addSubview(timeSignatureUpperLabel)
        timeSignatureUpperLabel.topAnchor.constraint(equalTo: timeSignatureTitleLabel.bottomAnchor, constant: 30).isActive = true
        timeSignatureUpperLabel.centerXAnchor.constraint(equalTo: metronomeContainerView.centerXAnchor).isActive = true
        
        metronomeContainerView.addSubview(lessUpperTimeSignatureButton)
        lessUpperTimeSignatureButton.trailingAnchor.constraint(equalTo: timeSignatureUpperLabel.leadingAnchor, constant: -20).isActive = true
        lessUpperTimeSignatureButton.centerYAnchor.constraint(equalTo: timeSignatureUpperLabel.centerYAnchor).isActive = true

        metronomeContainerView.addSubview(moreUpperTimeSignatureButton)
        moreUpperTimeSignatureButton.leadingAnchor.constraint(equalTo: timeSignatureUpperLabel.trailingAnchor, constant: 20).isActive = true
        moreUpperTimeSignatureButton.centerYAnchor.constraint(equalTo: timeSignatureUpperLabel.centerYAnchor).isActive = true

        metronomeContainerView.addSubview(timeSignatureLowerLabel)
        timeSignatureLowerLabel.topAnchor.constraint(equalTo: timeSignatureUpperLabel.bottomAnchor, constant: 40).isActive = true
        timeSignatureLowerLabel.centerXAnchor.constraint(equalTo: metronomeContainerView.centerXAnchor).isActive = true
        
        metronomeContainerView.addSubview(lessLowerTimeSignatureButton)
        lessLowerTimeSignatureButton.trailingAnchor.constraint(equalTo: timeSignatureLowerLabel.leadingAnchor, constant: -20).isActive = true
        lessLowerTimeSignatureButton.centerYAnchor.constraint(equalTo: timeSignatureLowerLabel.centerYAnchor).isActive = true

        metronomeContainerView.addSubview(moreLowerTimeSignatureButton)
        moreLowerTimeSignatureButton.leadingAnchor.constraint(equalTo: timeSignatureLowerLabel.trailingAnchor, constant: 20).isActive = true
        moreLowerTimeSignatureButton.centerYAnchor.constraint(equalTo: timeSignatureLowerLabel.centerYAnchor).isActive = true

        metronomeContainerView.addSubview(metronomeToggle)
        metronomeToggle.heightAnchor.constraint(equalToConstant: MetronomeView.buttonSize).isActive = true
        metronomeToggle.topAnchor.constraint(equalTo: timeSignatureLowerLabel.bottomAnchor, constant: 30).isActive = true
        metronomeToggle.centerXAnchor.constraint(equalTo: metronomeContainerView.centerXAnchor).isActive = true
        metronomeToggle.bottomAnchor.constraint(equalTo: metronomeContainerView.bottomAnchor, constant: -20).isActive = true
    }
    
    func setupCheckpointsContainerView() {
        addSubview(checkpointsContainerView)
        checkpointsContainerView.topAnchor.constraint(equalTo: metronomeContainerView.bottomAnchor, constant: 10).isActive = true
        checkpointsContainerView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        checkpointsContainerView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        checkpointsContainerView.bottomAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        
        checkpointsContainerView.addSubview(songTitleLabel)
        songTitleLabel.leadingAnchor.constraint(equalTo: checkpointsContainerView.leadingAnchor, constant: 20).isActive = true
        songTitleLabel.trailingAnchor.constraint(equalTo: checkpointsContainerView.trailingAnchor, constant: -20).isActive = true
        songTitleLabel.topAnchor.constraint(equalTo: checkpointsContainerView.topAnchor, constant: 20).isActive = true
        
        checkpointsContainerView.addSubview(checkpointsView)
        checkpointsView.leadingAnchor.constraint(equalTo: checkpointsContainerView.leadingAnchor, constant: 20).isActive = true
        checkpointsView.trailingAnchor.constraint(equalTo: checkpointsContainerView.trailingAnchor, constant: -20).isActive = true
        checkpointsView.topAnchor.constraint(equalTo: songTitleLabel.bottomAnchor, constant: 20).isActive = true
        checkpointsView.bottomAnchor.constraint(equalTo: checkpointsContainerView.bottomAnchor, constant: -20).isActive = true
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
    
    @objc func metronomeToggleValueChanged() {
        metronomeToggle.isOn ? delegate?.turnMetronomeOn() : delegate?.turnMetronomeOff()
    }
    
    func setSongName(_ name: String) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        songTitleLabel.attributedText = NSAttributedString(string: name,
                                                           attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
    }
    
    func updateTimeSignature(lower: Int, upper: Int) {
        timeSignatureLowerLabel.text = "\(lower)"
        timeSignatureUpperLabel.text = "\(upper)"
    }
    
    func updateTempo(_ tempo: String) {
        tempoTextField.text = tempo
    }
    
    func hideCheckpointsView() {
        checkpointsContainerView.isHidden = true
    }
}
