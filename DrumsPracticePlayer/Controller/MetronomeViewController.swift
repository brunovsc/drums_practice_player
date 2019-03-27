//
//  MetronomeViewController.swift
//  DrumsPracticePlayer
//
//  Created by Bruno Vieira on 27/03/19.
//  Copyright © 2019 Bruno Vieira. All rights reserved.
//

import UIKit

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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Metronome"
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
}

extension MetronomeViewController: MetronomeViewDelegate {
    func lessLowerTimeSignatureButtonDidReceiveTouchUpInside() {
        
    }
    
    func moreLowerTimeSignatureButtonDidReceiveTouchUpInside() {
        
    }
    
    func lessUpperTimeSignatureButtonDidReceiveTouchUpInside() {
        
    }
    
    func moreUpperTimeSignatureButtonDidReceiveTouchUpInside() {
        
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
