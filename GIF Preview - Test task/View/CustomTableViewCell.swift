//
//  CustomTableViewCell.swift
//  GIF Preview - Test task
//
//  Created by Dmitry Likhaletov on 11.07.2020.
//  Copyright © 2020 Dmitry Likhaletov. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    static let reusableIdentifier = "reuseID"
    
    lazy var customImageView: CustomImageView = {
        var imageView = CustomImageView()
        imageView.contentMode = .center
        imageView.layer.cornerRadius = 30.0
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var imageIdLabel: UILabel = {
        var label = UILabel()
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupCustomImageView()
        setupImageIdLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCustomImageView() {
        addSubview(customImageView)
        NSLayoutConstraint.activate([
            customImageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 11),
            customImageView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            customImageView.widthAnchor.constraint(equalToConstant: 100),
            customImageView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    func setupImageIdLabel() {
        addSubview(imageIdLabel)
        NSLayoutConstraint.activate([
            imageIdLabel.leadingAnchor.constraint(equalTo: customImageView.trailingAnchor, constant: 11),
            imageIdLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func configure(with model: Model) {
        customImageView.loadImage(from: model.previewImageURL)
        imageIdLabel.text = "Image ID: " + model.imageID
    }
    
}
