//
//  RepoViewModel.swift
//  BrightwheelCodeChallenge
//
//  Created by Alex Hoff on 4/23/18.
//  Copyright © 2018 Alex Hoff. All rights reserved.
//

import Foundation
import UIKit

private let path = "/search/repositories"
private let searchVar = "all"
private let sortVar = "stars"
private let orderVar = "desc"

protocol RepoViewModifier {
    func navBarIsHidden(_ cond: Bool)
}

class RepoViewModel: NSObject {
    
    //Delegate object to manipulate the navigation bar
    var delegate: RepoViewModifier?
    
    //Repository request so that the request is not deallocated when the function goes out of scope
    fileprivate var repoRequest: AnyObject?
    
    //Contributor request so that the request is not deallocated when the function goes out of scope
    fileprivate var contributorRequests = [ApiContributorRequest]()
    
    //Array of repositories
    fileprivate var repositories: [Repo]?
    
    //Pre-fetching queue and and ooperations array
    fileprivate let contributorLoadQueue = OperationQueue()
    fileprivate var contributorLoadOperations = [IndexPath: ContributorLoadOperation]()
    
    
    override init() {
        super.init()

    }
    
    func getRepos(completion: @escaping () -> Void) {
        let queryItems = [URLQueryItem(name: "q", value: searchVar),
                          URLQueryItem(name: "sort", value: sortVar),
                          URLQueryItem(name: "order", value: orderVar),
                          URLQueryItem(name: "page", value: "1"),
                          URLQueryItem(name: "per_page", value: "100")]
        let url = URL.buildUrlWithPath(path, queryItems)
        let apiRequest = ApiRepoRequest(url: url)
        repoRequest = apiRequest
        apiRequest.load { [weak self] (session: Session?) in
            guard let strongSelf = self else { fatalError("Weak self deallocated") }
            guard let repos = session?.items else { return }
            strongSelf.repositories = repos
            completion()
//            strongSelf.getTopContributors {
//                completion()
//            }
        }
    }
    
    func getTopContributors(completion: @escaping () -> Void) {
        let group = DispatchGroup()
        guard let repos = repositories else { return }
        
        for i in 0..<repos.count {
            group.enter()
            getTopContributorWithUrl(repos[i].contributorsUrl, completion: { [weak self] (contributor) in
                guard let strongSelf = self else { fatalError("Weak self deallocated") }
                strongSelf.repositories?[i].topContributor = contributor
                print("Result = \(contributor)")
                group.leave()
            })
        }
        group.notify(queue: DispatchQueue.main) {
            print("All tasks complete")
            completion()
        }
    }
    
    func getTopContributorWithUrl(_ urlString: String, completion: @escaping (String) -> Void) {
        guard let url = URL(string: urlString) else { fatalError("Could not create URL") }
        let apiRequest = ApiContributorRequest(url: url)
        contributorRequests.append(apiRequest)
        apiRequest.load { (contributor) in
            guard let topContributor = contributor else { return }
            completion(topContributor.login)
        }
    }
}

extension RepoViewModel: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return repositories?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: RepoTableViewCell.identifier, for: indexPath) as? RepoTableViewCell,
            let repo = repositories {
            cell.item = repo[indexPath.section]
            cell.layer.cornerRadius = 5
            return cell
        }
        return UITableViewCell()
    }
    
}

extension RepoViewModel: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView;
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        if velocity.y > 0  {
            delegate?.navBarIsHidden(true)
            
        } else {
            delegate?.navBarIsHidden(false)
        }
    }
}
