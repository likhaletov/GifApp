//
//  Extensions.swift
//  GIF Preview - Test task
//
//  Created by Dmitry Likhaletov on 09.07.2020.
//  Copyright © 2020 Dmitry Likhaletov. All rights reserved.
//

import Foundation

extension URL {
    
    static func with(string: String, page: String = "") -> URL {
        
        let query = string.replacingOccurrences(of: " ", with: "%20")
        
        if let url = URL(string: query + "&pos=" + page) {
            return url
        } else {
            let url = URL(string: Settings.api)
            guard let defaultUrl = url else { fatalError("bad url") }
            return defaultUrl
        }
        
        
    }
    
}
