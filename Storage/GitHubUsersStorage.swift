//
//  GitHubUsersStorage.swift
//  GitHubUsers
//
//  Created by Sergii on 10/27/20.
//

import Foundation
import CoreData

class GitHubUsersStorage {
    lazy var persistentContainer: NSPersistentContainer = {
            let container = NSPersistentContainer(name: "GitHubUsersDataModel")
            container.loadPersistentStores { description, error in
                if let error = error {
                    fatalError("Unable to load persistent stores: \(error)")
                }
            }
            return container
        }()
    
    init() {
        
    }
    
    private func newBatchInsertRequest(with quakeDictionaryList: [[String: Any]]) -> NSBatchInsertRequest {
        let batchInsert: NSBatchInsertRequest
        
        // Provide one dictionary at a time when the block is called.
        var index = 0
        let total = quakeDictionaryList.count
        batchInsert = NSBatchInsertRequest(entityName: "GitHubUser", dictionaryHandler: { dictionary in
            guard index < total else { return true }
            dictionary.addEntries(from: quakeDictionaryList[index])
            index += 1
            return false
        })
        return batchInsert
    }
    
    private func newTaskContext() -> NSManagedObjectContext {
        // Create a private queue context.
        let taskContext = persistentContainer.newBackgroundContext()
        taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return taskContext
    }
    
    func store(gitHubUsers:[[String: Any]]) throws {
        var performError: Error?

        // taskContext.performAndWait runs on the URLSession's delegate queue
        // so it won’t block the main thread.
        let taskContext = newTaskContext()
        taskContext.performAndWait {
            let batchInsert = self.newBatchInsertRequest(with: gitHubUsers)
            batchInsert.resultType = .statusOnly
            
            if let batchInsertResult = try? taskContext.execute(batchInsert) as? NSBatchInsertResult,
                let success = batchInsertResult.result as? Bool, success {
                return
            }
            performError = GitHubUsersStorageError.batchInsertError
        }

        if let error = performError {
            throw error
        }
    }
    
    func fetch(count:Int, offset:Int) -> [GitHubUser]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GitHubUser")
        fetchRequest.fetchLimit = count
        fetchRequest.fetchOffset = offset
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let taskContext = newTaskContext()
        var fetchResultTmp:[GitHubUser]?
        taskContext.performAndWait {
            if let fetchResult = try? taskContext.fetch(fetchRequest) as? [GitHubUser] {
                fetchResultTmp = fetchResult
            }
        }
        return fetchResultTmp
    }
}
