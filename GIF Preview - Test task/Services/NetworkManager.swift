//
//  FetchData.swift
//  GIF Preview - Test task
//
//  Created by Dmitry Likhaletov on 09.07.2020.
//  Copyright © 2020 Dmitry Likhaletov. All rights reserved.
//

import UIKit

class NetworkManager: NetworkProtocol {
    
    func obtainData(from url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let _ = response, let data = data else { return }
            
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(data))
            }
            
        }
        task.resume()
    }
    
}
