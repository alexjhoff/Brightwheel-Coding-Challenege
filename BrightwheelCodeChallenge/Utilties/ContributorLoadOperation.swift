//
//  ContributorLoadOperation.swift
//  BrightwheelCodeChallenge
//
//  Created by Alex Hoff on 4/25/18.
//  Copyright © 2018 Alex Hoff. All rights reserved.
//

import Foundation

typealias ContributorLoadOperationCompletionHandlerType = ((String) -> ())?

class ContributorLoadOperation: Operation {
    var url: String
    var completionHandler: ContributorLoadOperationCompletionHandlerType
    var request: ApiContributorRequest
    var contributor: String?
    
    init(url: String, request: ApiContributorRequest) {
        self.url = url
        self.request = request
    }
    
    override func main() {
        if isCancelled {
            return
        }
        
        guard let url = URL(string: url) else { fatalError("Could not create URL") }
        let apiRequest = ApiContributorRequest(url: url)
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

