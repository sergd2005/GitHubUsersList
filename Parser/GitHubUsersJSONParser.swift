//
//  GitHubUsersJSONParser.swift
//  GitHubUsers
//
//  Created by Sergii on 10/27/20.
//

import Foundation

class GitHubUsersJSONParser: GitHubUsersParser {
    func parseData(jsonData: Data) -> [[String:Any]]? {
        do {
            let jsonRootObject = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
            var parsedObjects = Array<[String:Any]>()
            if let array = jsonRootObject as? [[String:Any]] {
                for object in array {
                    let id = object["id"] as! Int
                    let login = object["login"] as! String
                    let avatar_url = object["avatar_url"] as! String
                    parsedObjects.append(["id":id,"login":login,"avatar_url":avatar_url])
                }
            }
            return parsedObjects
        } catch {
            return nil
        }
    }
}
