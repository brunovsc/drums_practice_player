//
//  CheckpointsView.swift
//  DrumsPracticePlayer
//
//  Created by Bruno Vieira on 27/03/19.
//  Copyright © 2019 Bruno Vieira. All rights reserved.
//

import UIKit

protocol CheckpointsViewDelegate {
    func previousCheckpointButtonDidReceiveTouchUpInside()
    func nextCheckpointButtonDidReceiveTouchUpInside()
}

class CheckpointsView: UIStackView {
    
    static let buttonSize: CGFloat = 40
    var delegate: CheckpointsViewDelegate?
    
    lazy var previousButton: UIButton = {
        return UIButton.roundButton(imageName: "top", size: CheckpointsView.buttonSize, target: self, selector: #selector(previousButtonDidReceiveTouchUpInside))
    }()
    
    lazy var nextButton: UIButton = {
        return UIButton.roundButton(imageName: "bottom", size: CheckpointsView.buttonSize, target: self, selector: #selector(nextButtonDidReceiveTouchUpInside))
    }()
    
    var pickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.showsSelectionIndicator = false
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    convenience init(delegate: CheckpointsViewDelegate?,
                     pickerViewDelegate: UIPickerViewDelegate?,
                     pickerViewDataSource: UIPickerViewDataSource?) {
        self.init()
        self.delegate = delegate
        self.pickerView.delegate = pickerViewDelegate
        self.pickerView.dataSource = pickerViewDataSource
        setupView()
    }
    
    func setupView() {
        addArrangedSubview(previousButton)
        addArrangedSubview(pickerView)
        addArrangedSubview(nextButton)
        axis = .vertical
        alignment = .center
        distribution = .equalSpacing
        spacing = 10.0
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(greaterThanOrEqualToConstant: 150).isActive = true
        heightAnchor.constraint(lessThanOrEqualToConstant: 250).isActive = true
    }
    
    func reloadCheckpoints() {
        pickerView.reloadAllComponents()
    }
    
    @objc func previousButtonDidReceiveTouchUpInside() {
        if pickerView.selectedRow(inComponent: 0) - 1 >= 0 {
            pickerView.selectRow(pickerView.selectedRow(inComponent: 0) - 1, inComponent: 0, animated: true)
            delegate?.previousCheckpointButtonDidReceiveTouchUpInside()
        }
    }
    
    @objc func nextButtonDidReceiveTouchUpInside() {
        if pickerView.selectedRow(inComponent: 0) + 1 < pickerView.numberOfRows(inComponent: 0) {
            pickerView.selectRow(pickerView.selectedRow(inComponent: 0) + 1, inComponent: 0, animated: true)
            delegate?.nextCheckpointButtonDidReceiveTouchUpInside()
        }
    }
}
