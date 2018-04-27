//
//  MockSession.swift
//  BrightwheelCodeChallenge
//
//  Created by Alex Hoff on 4/27/18.
//  Copyright © 2018 Alex Hoff. All rights reserved.
//

import Foundation

// Mock session acts as an offline session for testing our network requests by reading json
// data from a file and then adding it to a completion handler with a mock URL response
class MockSession: URLSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        if let path = Bundle.main.path(forResource: "MockDataFile", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                completionHandler(data, response, nil)
                return MockDataTask()
            } catch {
                print("Mock data fetch error")
            }
        }
        completionHandler(Data(), nil, nil)
        return MockDataTask()
    }
}
