//
//  SongTableViewCell.swift
//  DrumsPracticePlayer
//
//  Created by Bruno Vieira on 05/03/19.
//  Copyright © 2019 Bruno Vieira. All rights reserved.
//

import UIKit

class SongTableViewCell: UITableViewCell {
    
     var model: Song? {
        didSet {
            titleLabel.attributedText = NSAttributedString(string: model?.title ?? "",
                                                           attributes: [NSAttributedString.Key.foregroundColor: UIColor.white,
                                                                        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14.0, weight: .regular)])
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Setup
    private func setupView() {
        backgroundColor = .dark_green
        selectionStyle = .none
        setupContainerView()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        if selected {
            containerView.backgroundColor = .yellow
            titleLabel.attributedText = NSAttributedString(string: titleLabel.attributedText?.string ?? "",
                                                           attributes: [NSAttributedString.Key.foregroundColor: UIColor.white,
                                                                        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .semibold)])
        } else {
            containerView.backgroundColor = .green
            titleLabel.attributedText = NSAttributedString(string: titleLabel.attributedText?.string ?? "",
                                                           attributes: [NSAttributedString.Key.foregroundColor: UIColor.white,
                                                                        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14.0, weight: .regular)])
        }
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
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    func setupContainerView() {
        addSubview(containerView)
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        containerView.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        setupTitleLabel()
    }
    
    func setupTitleLabel() {
        containerView.addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10).isActive = true
        titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10).isActive = true
    }
}
