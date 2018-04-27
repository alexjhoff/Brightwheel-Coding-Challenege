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
    
    //Array of repositories
    fileprivate var repositories: [Repo]?
    
    //Pre-fetching queue and and operations array
    fileprivate let contributorLoadQueue = OperationQueue()
    fileprivate var contributorLoadOperations = [IndexPath: ContributorLoadOperation]()
    
    
    override init() {
        super.init()
    }
    
    // Network request for 100 most starred repositories of all time
    func getRepos(completion: @escaping () -> Void) {
        let queryItems = [URLQueryItem(name: "q", value: searchVar),
                          URLQueryItem(name: "sort", value: sortVar),
                          URLQueryItem(name: "order", value: orderVar),
                          URLQueryItem(name: "page", value: "1"),
                          URLQueryItem(name: "per_page", value: "100")]
        let url = URL.buildUrlWithPath(path, queryItems)
        let urlSession = URLSession.shared
        let apiRequest = ApiRepoRequest(url: url, session: urlSession)
        repoRequest = apiRequest
        apiRequest.load { [weak self] (session: Session?) in
            guard let strongSelf = self else { fatalError("Weak self deallocated") }
            guard let repos = session?.items else { return }
            strongSelf.repositories = repos
            completion()
        }
    }
}

// MARK:- Table View Data Source
extension RepoViewModel: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return repositories?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get reusable RepoTableViewCell and make sure repositories exists
        if let cell = tableView.dequeueReusableCell(withIdentifier: RepoTableViewCell.identifier, for: indexPath) as? RepoTableViewCell,
            let repo = repositories {
            // Set cells repo and corner radius
            cell.item = repo[indexPath.section]
            cell.layer.cornerRadius = 5
            
            // Check if the repositories array already contains the top contributor
            let contributorUrl = repo[indexPath.section].contributorsUrl
            if let contributor = repo[indexPath.section].topContributor {
                cell.setContributor(contributor, contributorUrl)
                return cell
            }
            
            /*
             If not, check if the top contributor load operation is already been completed
             and is sitting with the top contributor in the operations array.
             If so the repositories array is updated and the cells contributor is set.
             */
            if let contributorLoadOperation = contributorLoadOperations[indexPath],
                let contributor = contributorLoadOperation.contributor {
                repositories?[indexPath.section].topContributor = contributor
                cell.setContributor(contributor, contributorUrl)
            }
            /*
             If the load operation has not been made it is added to the operation queue
             and the repositories array and cell contributor are set once the operation is complete
            */
            else {
                let contributorLoadOperation = ContributorLoadOperation(url: contributorUrl)
                contributorLoadOperation.completionHandler = { [weak self] (contributor) in
                    guard let strongSelf = self else { return }
                    strongSelf.repositories?[indexPath.section].topContributor = contributor
                    cell.setContributor(contributor, contributorUrl)
                    strongSelf.contributorLoadOperations.removeValue(forKey: indexPath)
                }
                contributorLoadQueue.addOperation(contributorLoadOperation)
                contributorLoadOperations[indexPath] = contributorLoadOperation
            }
            return cell
        }
        return UITableViewCell()
    }
    
    // If the cell goes out of view and the operation for that cell is not complete the opeartion is canceled
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let contributorLoadOperation = contributorLoadOperations[indexPath] else { return }
        contributorLoadOperation.cancel()
        contributorLoadOperations.removeValue(forKey: indexPath)
    }
    
}

// MARK:- Table View Delegate
extension RepoViewModel: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    // Creates spacing between cells
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView;
    }
    
    // Determines if the navigation bar should be hidden based on scroll
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity.y > 0  {
            delegate?.navBarIsHidden(true)
            
        } else if velocity.y < 0 {
            delegate?.navBarIsHidden(false)
        }
    }
}

// MARK:- Table View Data Source Prefetching
extension RepoViewModel: UITableViewDataSourcePrefetching {
    // Load top contributor operations into the operation queue for cells that
    // will show soon if those operations do not already exist
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if let _ = contributorLoadOperations[indexPath] { return }
            
            if let contributorUrl = repositories?[indexPath.section].contributorsUrl {
                let contributorLoadOperation = ContributorLoadOperation(url: contributorUrl)
                contributorLoadQueue.addOperation(contributorLoadOperation)
                contributorLoadOperations[indexPath] = contributorLoadOperation
            }
        }
    }
    
    // Cancel top contributor operations for rows out of scope whos operations are
    // not yet completed
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            guard let contributorLoadOperation = contributorLoadOperations[indexPath] else { return }
            contributorLoadOperation.cancel()
            contributorLoadOperations.removeValue(forKey: indexPath)
        }
    }
}
