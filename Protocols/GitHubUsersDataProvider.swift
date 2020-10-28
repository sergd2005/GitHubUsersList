//
//  GitHubUsersDataProvider.swift
//  GitHubUsers
//
//  Created by Sergii on 10/27/20.
//

import Foundation

protocol GitHubUsersDataProvider {
    func loadItems(page:Int, per_page:Int, completionHandler: @escaping (Data?,Error?) -> Void)
}
