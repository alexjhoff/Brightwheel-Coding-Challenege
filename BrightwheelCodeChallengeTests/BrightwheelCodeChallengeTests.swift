//
//  BrightwheelCodeChallengeTests.swift
//  BrightwheelCodeChallengeTests
//
//  Created by Alex Hoff on 4/23/18.
//  Copyright © 2018 Alex Hoff. All rights reserved.
//

import XCTest
@testable import BrightwheelCodeChallenge

class BrightwheelCodeChallengeTests: XCTestCase {
    
    fileprivate var request: AnyObject?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testRepoUrlBuilt() {
        // Given
        let targetUrl = URL(string: "https://api.github.com/search/repositories?q=all&sort=stars&order=desc&page=1&per_page=100")
        
        // When
        let path = "/search/repositories"
        let searchVar = "all"
        let sortVar = "stars"
        let orderVar = "desc"
        let queryItems = [URLQueryItem(name: "q", value: searchVar),
                          URLQueryItem(name: "sort", value: sortVar),
                          URLQueryItem(name: "order", value: orderVar),
                          URLQueryItem(name: "page", value: "1"),
                          URLQueryItem(name: "per_page", value: "100")]
        let testUrl = URL.buildUrlWithPath(path, queryItems)
        
        // Then
        XCTAssertEqual(testUrl, targetUrl, "URL was not built correctly")
    }
    
    func testAPICallCompletes() {
        // Given
        let testUrl = URL(string: "https://api.github.com/search/repositories?q=all&sort=stars&order=desc&page=1&per_page=100")
        let promise = expectation(description: "Download github repo data")
        
        // When
        let apiRequest = ApiRepoRequest(url: testUrl!)
        request = apiRequest
        apiRequest.load { (session: Session?) in
            //Make sure data was downloaded
            XCTAssertNotNil(session, "No session data downloaded")
            
            promise.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
}
