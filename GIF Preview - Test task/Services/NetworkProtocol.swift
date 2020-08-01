//
//  NetworkProtocol.swift
//  GIF Preview - Test task
//
//  Created by Dmitry Likhaletov on 01.08.2020.
//  Copyright © 2020 Dmitry Likhaletov. All rights reserved.
//

import Foundation

protocol NetworkProtocol: AnyObject {
    func obtainData(from url: URL, completion: @escaping (Result<Data, Error>) -> Void)
}
