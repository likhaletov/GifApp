//
//  DataJsonDecoder.swift
//  GIF Preview - Test task
//
//  Created by Dmitry Likhaletov on 09.07.2020.
//  Copyright © 2020 Dmitry Likhaletov. All rights reserved.
//

import Foundation

class DataJsonDecoder {
    
    func decode<T: Decodable>(model: T.Type, from data: Data) -> T {
        let decoder = JSONDecoder()
        
        do {
            let result = try decoder.decode(model, from: data)
            return result
        } catch let error {
            fatalError(error.localizedDescription)
        }
        
    }
    
}
