//
//  RepoModel.swift
//  BrightwheelCodeChallenge
//
//  Created by Alex Hoff on 4/23/18.
//  Copyright © 2018 Alex Hoff. All rights reserved.
//

import Foundation

struct Session: Codable {
    let totalCount: Int
    let incompleteResults: Bool
    let items: [Repo]
}

struct Repo: Codable {
    let id: Int
    let fullName: String
    let description: String
    let contributorsUrl: String
    let stargazersCount: Int
    
    // This value will be updated when the contributor api call is made
    var topContributor: String?
}

struct Contributor: Codable {
    let login: String
    let avatarUrl: String
    let contributions: Int
}
