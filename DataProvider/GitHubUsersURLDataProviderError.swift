//
//  GitHubUsersDataProviderError.swift
//  GitHubUsers
//
//  Created by Sergii on 10/27/20.
//

import Foundation
enum GitHubUsersURLDataProviderError: Error {
    case urlError
    case networkUnavailable
}
