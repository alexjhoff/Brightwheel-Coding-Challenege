//
//  NetworkRequest.swift
//  BrightwheelCodeChallenge
//
//  Created by Alex Hoff on 4/23/18.
//  Copyright © 2018 Alex Hoff. All rights reserved.
//

import Foundation

// Network reques protocol lays out a framework for network request 
protocol NetworkRequest: class {
    associatedtype Model
    func load(withCompletion completion: @escaping (Model?) -> Void)
    func decode(_ data: Data) -> Model?
}

// Extend the network request functionality for all network load requests
extension NetworkRequest {
    // Standard URLSession data task request
    fileprivate func load(_ url: URL, _ session: URLSessionProtocol, withCompletion completion: @escaping (Model?) -> Void) {
        let task = session.dataTask(with: url, completionHandler: { [weak self] (data: Data?, response: URLResponse?, error: Error?) -> Void in
            // Make sure there are no errors
            if let error = error {
                print("Server error:", error)
                return
            } else if let data = data,
                let response = response as? HTTPURLResponse {
                // If data and response exist and response code is 200 continue
                if response.statusCode == 200 {
                    completion(self?.decode(data))
                } else {
                    // This likely fires if you make too many API calls to Github
                    // 403 code means you exceeded API rate limit for your IP address
                    print("Data error status: ", response.statusCode)
                }
            }
        })
        task.resume()
    }
}

// Class for making repo requests
class ApiRepoRequest {
    private let url: URL
    private let session: URLSessionProtocol
    
    init(url: URL, session: URLSessionProtocol) {
        self.url = url
        self.session = session
    }
}

extension ApiRepoRequest: NetworkRequest {
    // Decode data from JSON into Session object
    func decode(_ data: Data) -> Session? {
        do {
            let decoder = JSONDecoder()
            // New in Swift 4.1; must be running Swift 9.3 for this functionality to work
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let session = try decoder.decode(Session.self, from: data)
            return session
        } catch {
            print("ERROR: ", error)
            return nil
        }
    }
    
    func load(withCompletion completion: @escaping (Model?) -> Void) {
        load(url, session, withCompletion: completion)
    }
}

// Class for making contributor requests
class ApiContributorRequest {
    private let url: URL
    private let session: URLSessionProtocol
    
    init(url: URL, session: URLSessionProtocol) {
        self.url = url
        self.session = session
    }
}

extension ApiContributorRequest: NetworkRequest {
    // Decode data from JSON into Contributor array object
    func decode(_ data: Data) -> Contributor? {
        do {
            let decoder = JSONDecoder()
            // New in Swift 4.1; must be running Swift 9.3 for this functionality to work
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let cont = try decoder.decode([Contributor].self, from: data)
            return cont[0]
        } catch {
            print("ERROR: ", error)
            return nil
        }
    }

    func load(withCompletion completion: @escaping (Model?) -> Void) {
        load(url, session, withCompletion: completion)
    }
}





