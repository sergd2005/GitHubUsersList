//
//  GitHubUsersDataCoordinator.swift
//  GitHubUsers
//
//  Created by Sergii on 10/27/20.
//

import Foundation

class GitHubUsersDataCoordinator {
    var _dataProvider:GitHubUsersDataProvider
    var _storage:GitHubUsersStorage
    var _parser: GitHubUsersParser
    
    init(dataProvider:GitHubUsersDataProvider, storage:GitHubUsersStorage, parser: GitHubUsersParser) {
        _dataProvider = dataProvider
        _storage = storage
        _parser = parser
    }
    
    func loadItems(page:Int, per_page:Int, completionHandler: @escaping ([GitHubUser]?,Error?) -> Void) {
        _dataProvider.loadItems(page: page, per_page: per_page) { (data:Data?, error:Error?) in
            if let data = data {
                if let parsedObjects = self._parser.parseData(jsonData: data) {
                    if page == 1 {
                        self._storage.clean()
                    }
                    do {
                        try self._storage.store(gitHubUsers: parsedObjects)
                    } catch {
                        
                    }
                }
            }
            let users = self._storage.fetch(count: per_page, offset: (page - 1) * per_page)
            if let users = users {
                if users.count == 0  {
                    completionHandler(nil, nil)
                } else {
                    completionHandler(users, nil)
                }
            } else {
                completionHandler (nil, nil)
            }
        }
    }
}
