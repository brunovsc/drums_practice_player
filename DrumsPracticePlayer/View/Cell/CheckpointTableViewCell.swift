//
//  CheckpointTableViewCell.swift
//  DrumsPracticePlayer
//
//  Created by Bruno Vieira on 06/04/19.
//  Copyright © 2019 Bruno Vieira. All rights reserved.
//

import UIKit

protocol CheckpointTableViewCellDelegate {
    func deleteButtonDidReceiveTouchUpInside(in cell: CheckpointTableViewCell)
}

class CheckpointTableViewCell: UITableViewCell {
    
    static var buttonSize: CGFloat = 30
    
    var delegate: CheckpointTableViewCellDelegate?
    var model: Checkpoint? {
        didSet {
            if let time = model?.time {
                let timeString = time.asMinutesAndSeconds()
                infoLabel.text = "\(timeString) - \(model?.name ?? "-")"
            }
            
        }
    }
    
    lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.text = "TIME - NAME"
        label.textColor = .dark_green
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var deleteButton: UIButton = {
        return UIButton.roundButton(imageName: "trash", size: CheckpointTableViewCell.buttonSize, target: self, selector: #selector(deleteButtonDidReceiveTouchUpInside))
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .light_green
        
        addSubview(infoLabel)
        infoLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        infoLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        infoLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
        
        addSubview(deleteButton)
        deleteButton.leadingAnchor.constraint(equalTo: infoLabel.trailingAnchor, constant: 20).isActive = true
        deleteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        deleteButton.centerYAnchor.constraint(equalTo: infoLabel.centerYAnchor).isActive = true
    }
    
    @objc func deleteButtonDidReceiveTouchUpInside() {
        delegate?.deleteButtonDidReceiveTouchUpInside(in: self)
    }
}
