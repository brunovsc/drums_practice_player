//
//  SongTableViewCell.swift
//  DrumsPracticePlayer
//
//  Created by Bruno Vieira on 05/03/19.
//  Copyright © 2019 Bruno Vieira. All rights reserved.
//

import UIKit

protocol SongTableViewCellDelegate {
    func uploadButtonDidReceiveTouchUpInside(in cell: SongTableViewCell)
}

class SongTableViewCell: UITableViewCell {
    
    var delegate: SongTableViewCellDelegate?
    var model: Song? {
        didSet {
            let infoText = NSMutableAttributedString(attributedString: NSAttributedString(string: "\(model?.title ?? "")", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white,
                                                                                                                                        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14.0, weight: .regular)]))
            if let artist = model?.artist {
                let artistText = NSAttributedString(string: "\n\(artist)", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white,
                                                                                        NSAttributedString.Key.font: UIFont.italicSystemFont(ofSize: 14.0)])
                infoText.append(artistText)
            }
            titleLabel.attributedText = infoText
            uploadButton.isHidden = model?.id != nil
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    //MARK: Setup
    private func setupView() {
        backgroundColor = .dark_green
        selectionStyle = .none
        setupContainerView()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        containerView.backgroundColor = selected ? .yellow : .green
    }
    
    lazy var containerView: UIView = {
        let container = UIView()
        container.layer.cornerRadius = 5
        container.layer.shadowRadius = 5.0
        container.layer.shadowOpacity = 0.3
        container.layer.shadowOffset = CGSize(width: 0, height: 2)
        container.layer.masksToBounds = false
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .blue
        return container
    }()
    
    lazy var titleLabel: UILabel = {
        let title = UILabel()
        title.attributedText = NSAttributedString(string: "",
                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        title.numberOfLines = 0
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    lazy var uploadButton: UIButton = {
        return UIButton.roundButton(imageName: "upload", size: 30, target: self, selector: #selector(uploadButtonDidReceiveTouchUpInside))
    }()
    
    func setupContainerView() {
        addSubview(containerView)
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        containerView.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        
        containerView.addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10).isActive = true
        titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10).isActive = true
        
        containerView.addSubview(uploadButton)
        uploadButton.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 20).isActive = true
        uploadButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10).isActive = true
        uploadButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
    }
    
    
    @objc func uploadButtonDidReceiveTouchUpInside() {
        delegate?.uploadButtonDidReceiveTouchUpInside(in: self)
    }
}
