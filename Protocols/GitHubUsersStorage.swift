//
//  Storage.swift
//  GitHubUsers
//
//  Created by Sergii on 10/27/20.
//

import Foundation

protocol GitHubUsersStorage {
    func store(gitHubUsers:[[String: Any]]) throws
    func fetch(count:Int, offset:Int) -> [GitHubUser]?
}
