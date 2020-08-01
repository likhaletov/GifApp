//
//  FetchData.swift
//  GIF Preview - Test task
//
//  Created by Dmitry Likhaletov on 09.07.2020.
//  Copyright © 2020 Dmitry Likhaletov. All rights reserved.
//

import UIKit

class DataFetcher {
    
    func obtain(from url: URL, completion: @escaping ((Data) -> Void), completionError: @escaping ((Error) -> Void)) {
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard response != nil else { return }
            
            if let error = error {
                completionError(error)
            } else if let data = data {
                completion(data)
            }
            
        }
        task.resume()
    }
    
}
