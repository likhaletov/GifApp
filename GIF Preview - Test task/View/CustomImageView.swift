//
//  CustomImageView.swift
//  GIF Preview - Test task
//
//  Created by Dmitry Likhaletov on 11.07.2020.
//  Copyright © 2020 Dmitry Likhaletov. All rights reserved.
//

import UIKit

var imageCache: NSCache<AnyObject, AnyObject> = {
    let cache = NSCache<AnyObject, AnyObject>()
    return cache
}()

class CustomImageView: UIImageView {
    
    lazy var spinner: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
//    var imageUrlString: String?
    
    var task: URLSessionDataTask!
    
    func loadImage(from url: URL) {
        
//        imageUrlString = url.absoluteString
        
        image = nil
        
        addSpinner()
        
        if let task = task {
            task.cancel()
        }
        
        if let imageFromCache = imageCache.object(forKey: url.absoluteString as AnyObject) as? UIImage {
            self.image = imageFromCache
            
            print("Load from cache")
            removeSpinner()
            return
        }
        
        task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let data = data, let imageToCache = UIImage(data: data) else {
                print("Can't load image")
                return
            }
            
            print("THREAD \(Thread.current)")
            
            DispatchQueue.main.async {
                
//                if self.imageUrlString == url.absoluteString {
                    self.image = imageToCache
                    imageCache.setObject(imageToCache, forKey: url.absoluteString as AnyObject)
                    print("PUT \(url.absoluteString) to cache")
//                }

                print("Image downloaded")
                self.removeSpinner()
            }
            
        }
        
        task.resume()
        
    }
    
    func addSpinner() {
        addSubview(spinner)
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        spinner.startAnimating()
    }
    
    func removeSpinner() {
        spinner.removeFromSuperview()
    }
    
}
