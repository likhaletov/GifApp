//
//  FetchData.swift
//  GIF Preview - Test task
//
//  Created by Dmitry Likhaletov on 09.07.2020.
//  Copyright © 2020 Dmitry Likhaletov. All rights reserved.
//

import UIKit

enum NetworkError: Error {
    case error
}

class NetworkManager {
    
    func obtainData(from url: URL, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard response != nil else { return }
            guard let data = data else { return }
            
            if error != nil {
                completion(.failure(.error))
            } else {
                completion(.success(data))
            }
            
        }
        task.resume()
    }
    
}
