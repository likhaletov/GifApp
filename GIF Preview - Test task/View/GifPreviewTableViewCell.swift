//
//  GifPreviewTableViewCell.swift
//  GIF Preview - Test task
//
//  Created by Dmitry Likhaletov on 11.07.2020.
//  Copyright © 2020 Dmitry Likhaletov. All rights reserved.
//

import UIKit

class GifPreviewTableViewCell: UITableViewCell {
    
    static let reusableID = "id"
    
    lazy var gifImageView: CustomImageView = {
        var imageView = CustomImageView()
        imageView.contentMode = .center
        imageView.layer.cornerRadius = 30.0
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var gifIdLabel: UILabel = {
        var label = UILabel()
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCustomImageView()
        setupImageIdLabel()
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCustomImageView() {
        addSubview(gifImageView)
        NSLayoutConstraint.activate([
            gifImageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 11),
            gifImageView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            gifImageView.widthAnchor.constraint(equalToConstant: 100),
            gifImageView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    func setupImageIdLabel() {
        addSubview(gifIdLabel)
        NSLayoutConstraint.activate([
            gifIdLabel.leadingAnchor.constraint(equalTo: gifImageView.trailingAnchor, constant: 11),
            gifIdLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func configure(with model: Model) {
        gifImageView.loadImage(from: model.previewImageURL)
        gifIdLabel.text = "Image ID: " + model.imageID
    }
    
}
