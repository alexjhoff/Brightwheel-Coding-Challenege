//
//  ContributorLoadOperation.swift
//  BrightwheelCodeChallenge
//
//  Created by Alex Hoff on 4/25/18.
//  Copyright © 2018 Alex Hoff. All rights reserved.
//

import Foundation

// Reusable completion handler
typealias ContributorLoadOperationCompletionHandlerType = ((String) -> ())?

// Operation class for loading top contributors asynchronously
class ContributorLoadOperation: Operation {
    // Top contributor URL string
    var url: String
    
    // Reusable completion handler
    var completionHandler: ContributorLoadOperationCompletionHandlerType
    
    // Contributor request so that the request is not deallocated when the function goes out of scope
    var request: ApiContributorRequest?
    
    // Contributor variable to be set once the api call has been made
    var contributor: String?
    
    init(url: String) {
        self.url = url
    }
    
    override func main() {
        if isCancelled {
            return
        }
        
        /*
         From the url given instantiate ApiContributorRequest, set it to request so
         it is not deallocated while the asynchronouse api call is run and
         set the contributor variable and call the completion handler when
         the api request is complete
        */
        guard let url = URL(string: url) else { fatalError("Could not create URL") }
        let urlSession = URLSession.shared
        let apiRequest = ApiContributorRequest(url: url, session: urlSession)
        request = apiRequest
        apiRequest.load { [weak self] (contributor) in
            guard let strongSelf = self else { return }
            guard !strongSelf.isCancelled,
                let topContributor = contributor else { return }
            
            strongSelf.contributor = topContributor.login
            strongSelf.completionHandler?(topContributor.login)
        }
    }
}

