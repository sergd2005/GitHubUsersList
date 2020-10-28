//
//  GitHubUsersDataProviderError.swift
//  GitHubUsers
//
//  Created by Sergii on 10/27/20.
//

import Foundation
enum GitHubUsersDataProviderError: Error {
    case urlError
    case networkUnavailable
}
