//
//  MetronomeViewController.swift
//  DrumsPracticePlayer
//
//  Created by Bruno Vieira on 27/03/19.
//  Copyright © 2019 Bruno Vieira. All rights reserved.
//

import UIKit
import AVFoundation

class MetronomeViewController: UIViewController {
    
    let metronome = MetronomePlayer()
    var song: Song? = nil
    
    lazy var metronomeView = MetronomeView(delegate: self,
                                           textFieldDelegate: self,
                                           pickerViewDelegate: self,
                                           pickerViewDataSource: self)
    
    lazy var scrollView: UIKeyboardScrollView = {
        let sv = UIKeyboardScrollView()
        sv.backgroundColor = .dark_green
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    convenience init(song: Song) {
        self.init()
        self.song = song
        initializeMetronome()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Metronome"
        navigationItem.setLeftBarButton(UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonDidReceiveTouchUpInside)), animated: false)
        view.backgroundColor = .dark_green
        view.addSubview(scrollView)
        scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        scrollView.addSubview(metronomeView)
        metronomeView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        metronomeView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        metronomeView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        metronomeView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        metronomeView.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
        metronomeView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        if let song = song {
            metronomeView.setSongName(song.title ?? "-")
        } else {
            metronomeView.hideCheckpointsView()
        }
        initializeMetronome()
        metronome.tempo = Double(song?.metronome?.tempo ?? 120)
        metronome.tsUpper = song?.metronome?.timeSignatureUpper ?? 4
        metronome.tsLower = song?.metronome?.timeSignatureLower ?? 4
    }
    
    @objc func backButtonDidReceiveTouchUpInside() {
        metronome.stopMetronome()
        navigationController?.popViewController(animated: true)
    }
    
    func initializeMetronome() {
        guard let pathForSound = Bundle.main.path(forResource: "snizzap1", ofType: "wav"),
            let pathForAccent = Bundle.main.path(forResource: "snizzap2", ofType: "wav") else { return }
        
        let metronomeSoundURL = NSURL(fileURLWithPath: pathForSound)
        let metronomeAccentURL = NSURL(fileURLWithPath: pathForAccent)
        
        metronome.metronomeSoundPlayer = try? AVAudioPlayer(contentsOf: metronomeSoundURL as URL)
        metronome.metronomeAccentPlayer = try? AVAudioPlayer(contentsOf: metronomeAccentURL as URL)
        
        metronome.metronomeSoundPlayer.prepareToPlay()
        metronome.metronomeAccentPlayer.prepareToPlay()
    }
}

extension MetronomeViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        scrollView.activeField = textField
        scrollView.lastOffset = scrollView.contentOffset
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        scrollView.activeField?.resignFirstResponder()
        scrollView.activeField = nil
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return true
    }
}

extension MetronomeViewController: MetronomeViewDelegate {
    func lessLowerTimeSignatureButtonDidReceiveTouchUpInside() {
        if (metronome.tsLower - 1 >= 1) {
            metronome.tsLower = metronome.tsLower - 1
            metronome.restartMetronome()
            metronomeView.updateTimeSignature(lower: metronome.tsLower, upper: metronome.tsUpper)
        }
    }
    
    func moreLowerTimeSignatureButtonDidReceiveTouchUpInside() {
        if (metronome.tsLower + 1 <= 16) {
            metronome.tsLower = metronome.tsLower + 1
            metronome.restartMetronome()
            metronomeView.updateTimeSignature(lower: metronome.tsLower, upper: metronome.tsUpper)
        }
    }
    
    func lessUpperTimeSignatureButtonDidReceiveTouchUpInside() {
        if (metronome.tsUpper - 1 >= 1) {
            metronome.tsUpper = metronome.tsUpper - 1
            metronome.restartMetronome()
            metronomeView.updateTimeSignature(lower: metronome.tsLower, upper: metronome.tsUpper)
        }
    }
    
    func moreUpperTimeSignatureButtonDidReceiveTouchUpInside() {
        if (metronome.tsUpper + 1 <= 19) {
            metronome.tsUpper = metronome.tsUpper + 1
            metronome.restartMetronome()
            metronomeView.updateTimeSignature(lower: metronome.tsLower, upper: metronome.tsUpper)
        }
    }
    
    func turnMetronomeOn() {
        metronome.startMetronome()
    }
    
    func turnMetronomeOff() {
        metronome.stopMetronome()
    }
}

extension MetronomeViewController: CheckpointsViewDelegate {
    func previousCheckpointButtonDidReceiveTouchUpInside() {
        
    }
    
    func nextCheckpointButtonDidReceiveTouchUpInside() {
        
    }
}

extension MetronomeViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return song?.checkpoints?[row].name ?? "-"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
}

extension MetronomeViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return song?.checkpoints?.count ?? 0
    }
}
