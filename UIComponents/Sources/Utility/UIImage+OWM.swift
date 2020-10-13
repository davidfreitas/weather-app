//
//  UIImage+Download.swift
//  forecast
//
//  Created by David Freitas on 13/10/20.
//  Copyright © 2020 SHAPE A/S. All rights reserved.
//

import UIKit

extension UIImage {
    @discardableResult
    static func owmImage(named name: String, completion: @escaping (UIImage?) -> Void) -> URLSessionDataTask {
        let requestURL = URL(string: "https://openweathermap.org/img/wn/\(name)@2x.png")!
        let urlRequest = URLRequest(url: requestURL)
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, urlResponse, error) in
            guard let data = data else {
                completion(nil)
                return
            }
            let image = UIImage(data: data)
            completion(image)
        }
        task.resume()
        return task
    }
}
