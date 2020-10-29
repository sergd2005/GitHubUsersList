//
//  GitHubUsersTests.swift
//  GitHubUsersTests
//
//  Created by Sergii on 10/26/20.
//

import XCTest
@testable import GitHubUsers

class FakeGitHubUsersDataProvider : GitHubUsersDataProvider {
    var dataToReturn:Data?
    var errorToReturn:Error?
    func loadItems(page: Int, per_page: Int, completionHandler: @escaping (Data?, Error?) -> Void) {
        completionHandler(dataToReturn, errorToReturn)
    }
}

class FakeGitHubUsersStorage : GitHubUsersStorage {
    var storedGitHubUsers:[[String : Any]]?
    var usersToFetch:[GitHubUser]?
    var cleaned:Bool = false
    func store(gitHubUsers: [[String : Any]]) throws {
        storedGitHubUsers = gitHubUsers
    }
    
    func fetch(count: Int, offset: Int) -> [GitHubUser]? {
        return usersToFetch
    }
    
    func clean() {
        cleaned = true
    }
}

class FakeGitHubUsersParser : GitHubUsersParser {
    var dataToParse:Data?
    var jsonObjectsToReturn:[[String : Any]]?
    func parseData(jsonData: Data) -> [[String : Any]]? {
        dataToParse = jsonData
        return jsonObjectsToReturn
    }
}

class GitHubUsersDataCoordinatorTests: XCTestCase {
    var coordinator:GitHubUsersDataCoordinator?
    var fakeDataProvider:FakeGitHubUsersDataProvider?
    var fakeStorage: FakeGitHubUsersStorage?
    var fakeParser:FakeGitHubUsersParser?
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        fakeDataProvider = FakeGitHubUsersDataProvider()
        fakeStorage = FakeGitHubUsersStorage()
        fakeParser = FakeGitHubUsersParser()
        coordinator = GitHubUsersDataCoordinator(dataProvider: fakeDataProvider!,
                                                 storage: fakeStorage!,
                                                 parser: fakeParser!)
    }
    
    func testLoadingItemsFromFirstPageOfFeedURL() {
        // GIVEN
        fakeDataProvider?.dataToReturn = Data(base64Encoded: "somedata")
        fakeDataProvider?.errorToReturn = nil
        fakeParser?.jsonObjectsToReturn = [["test":"value"]]
        let user = GitHubUser()
        fakeStorage?.usersToFetch = [user]
        
        // WHEN
        coordinator?.loadItems(page: 1, per_page: 20, completionHandler: { (users, error) in
            // THEN
            XCTAssert(error == nil)
            XCTAssert(self.fakeStorage?.usersToFetch == users)
            XCTAssert(self.fakeDataProvider?.dataToReturn == self.fakeParser?.dataToParse)
            XCTAssert(self.fakeStorage?.storedGitHubUsers?.count == 1)
            guard let dict = self.fakeStorage?.storedGitHubUsers?.first else {
                XCTFail()
                return
            }
            XCTAssert(dict["test"] as? String == "value")
            // storage should be cleaned when we got items and if it is first page
            XCTAssert(self.fakeStorage?.cleaned == true)
        })
    }
    
    func testLoadingItemsFromSecondPageOfFeedURL() {
        // GIVEN
        fakeDataProvider?.dataToReturn = Data(base64Encoded: "somedata")
        fakeDataProvider?.errorToReturn = nil
        fakeParser?.jsonObjectsToReturn = [["test":"value"]]
        let user = GitHubUser()
        fakeStorage?.usersToFetch = [user]
        
        // WHEN
        coordinator?.loadItems(page: 2, per_page: 20, completionHandler: { (users, error) in
            // THEN
            XCTAssert(error == nil)
            XCTAssert(self.fakeStorage?.usersToFetch == users)
            XCTAssert(self.fakeDataProvider?.dataToReturn == self.fakeParser?.dataToParse)
            XCTAssert(self.fakeStorage?.storedGitHubUsers?.count == 1)
            guard let dict = self.fakeStorage?.storedGitHubUsers?.first else {
                XCTFail()
                return
            }
            XCTAssert(dict["test"] as? String == "value")
            // storage should not be cleaned when we got items and if it is first page
            XCTAssert(self.fakeStorage?.cleaned == false)
        })
    }
    
    func testOfflineLoading() {
        // GIVEN
        fakeDataProvider?.dataToReturn = nil
        fakeDataProvider?.errorToReturn = nil
        fakeParser?.jsonObjectsToReturn = [["test":"value"]]
        let user = GitHubUser()
        fakeStorage?.usersToFetch = [user]
        
        // WHEN
        coordinator?.loadItems(page: 2, per_page: 20, completionHandler: { (users, error) in
            // THEN
            XCTAssert(error == nil)
            XCTAssert(self.fakeStorage?.usersToFetch == users)
            XCTAssert(self.fakeDataProvider?.dataToReturn == self.fakeParser?.dataToParse)
            XCTAssert(self.fakeStorage?.storedGitHubUsers == nil)
            // storage should not be cleaned when we got items and if it is first page
            XCTAssert(self.fakeStorage?.cleaned == false)
        })
    }
}
