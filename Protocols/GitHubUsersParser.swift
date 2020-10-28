//
//  GitHubUsersParser.swift
//  GitHubUsers
//
//  Created by Sergii on 10/27/20.
//

import Foundation

protocol GitHubUsersParser {
    func parseData(jsonData: Data) -> [[String:Any]]?
}
