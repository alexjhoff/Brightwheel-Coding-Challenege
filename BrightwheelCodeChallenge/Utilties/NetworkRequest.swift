//
//  NetworkRequest.swift
//  BrightwheelCodeChallenge
//
//  Created by Alex Hoff on 4/23/18.
//  Copyright © 2018 Alex Hoff. All rights reserved.
//

import Foundation

protocol NetworkRequest: class {
    associatedtype Model
    func load(withCompletion completion: @escaping (Model?) -> Void)
    func decode(_ data: Data) -> Model?
}

extension NetworkRequest {
    fileprivate func load(_ url: URL, withCompletion completion: @escaping (Model?) -> Void) {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        let task = session.dataTask(with: url, completionHandler: { [weak self] (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if let error = error {
                print("Server error:", error)
                return
            } else if let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 {
                completion(self?.decode(data))
            }
        })
        task.resume()
    }
}

class ApiRepoRequest {
    let url: URL
    
    init(url: URL) {
        self.url = url
    }
}

extension ApiRepoRequest: NetworkRequest {
    func decode(_ data: Data) -> Session? {
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let session = try decoder.decode(Session.self, from: data)
            return session
        } catch {
            print("ERROR: ", error)
            return nil
        }
    }
    
    func load(withCompletion completion: @escaping (Model?) -> Void) {
        load(url, withCompletion: completion)
    }
}

class ApiContributorRequest {
    let url: URL
    
    init(url: URL) {
        self.url = url
    }
}

extension ApiContributorRequest: NetworkRequest {
    func decode(_ data: Data) -> Contributor? {
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let cont = try decoder.decode([Contributor].self, from: data)
            return cont[0]
        } catch {
            print("ERROR: ", error)
            return nil
        }
    }
    
    func load(withCompletion completion: @escaping (Model?) -> Void) {
        load(url, withCompletion: completion)
    }
}





