//
//  URLSessionProtocol.swift
//  BrightwheelCodeChallenge
//
//  Created by Alex Hoff on 4/27/18.
//  Copyright © 2018 Alex Hoff. All rights reserved.
//

import Foundation

// This file creates our own URLSession Protocol which acts like a normal URLSession when used in
// production but which we can mock during testing
protocol URLSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}

extension URLSession : URLSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        
        let task = dataTask(with: url, completionHandler: completionHandler) as URLSessionDataTask
        return task as URLSessionDataTaskProtocol
    }
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {
    
}
