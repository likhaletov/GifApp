//
//  MainScreenView.swift
//  GIF Preview - Test task
//
//  Created by Dmitry Likhaletov on 01.08.2020.
//  Copyright © 2020 Dmitry Likhaletov. All rights reserved.
//

import UIKit

final class MainScreenView: UIView {
    
    lazy var resultTableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureResultTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureResultTableView() {
        resultTableView.rowHeight = 110.0
        resultTableView.register(GifPreviewTableViewCell.self, forCellReuseIdentifier: GifPreviewTableViewCell.reusableID)
        
        addSubview(resultTableView)
        
        NSLayoutConstraint.activate([
            resultTableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            resultTableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            resultTableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            resultTableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
}
