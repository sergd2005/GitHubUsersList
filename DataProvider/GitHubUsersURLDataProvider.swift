//
//  GitHubUsersDataProvider.swift
//  GitHubUsers
//
//  Created by Sergii on 10/27/20.
//

import Foundation

class GitHubUsersURLDataProvider: GitHubUsersDataProvider {
    let usersFeed = "https://api.github.com/users?"
    func loadItems(page:Int, per_page:Int, completionHandler: @escaping (Data?,Error?) -> Void) {
        let urlString = "\(usersFeed)per_page=\(per_page)&page=\(page)"
        guard let jsonURL = URL(string: urlString) else {
            completionHandler(nil, GitHubUsersURLDataProviderError.urlError)
            return
        }
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: jsonURL) { data, _, urlSessionError in
            // Alert any error returned by URLSession.
            guard urlSessionError == nil else {
                completionHandler(nil, urlSessionError)
                return
            }
            
            // Alert the user if no data comes back.
            guard let data = data else {
                completionHandler(nil, GitHubUsersURLDataProviderError.networkUnavailable)
                return
            }
            
            completionHandler(data, nil)
        }
        // Start the task.
        task.resume()
        
    }
}
