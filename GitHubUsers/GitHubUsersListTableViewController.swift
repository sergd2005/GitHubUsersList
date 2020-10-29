//
//  ViewController.swift
//  GitHubUsers
//
//  Created by Sergii on 10/26/20.
//

import UIKit

class GitHubUsersListTableViewController: UITableViewController {
    let userCellReuseIdentifier = "userCellReuseIdentifier"
    let loadMoreTableViewCell = "loadMoreTableViewCell"
    let imageLoader = ImageLoader()
    var users = Array<GitHubUser>()
    var loadMoreEnabled:Bool = true
    var page:Int = 1
    
    lazy var dataCoordinator:GitHubUsersDataCoordinator = {
        let storage = GitHubUsersCoreDataStorage()
        let parser = GitHubUsersJSONParser()
        let dataProvider = GitHubUsersURLDataProvider()
        return GitHubUsersDataCoordinator(dataProvider: dataProvider, storage: storage, parser: parser)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.register(GitHubUserTableViewCell.self, forCellReuseIdentifier:userCellReuseIdentifier)
        self.tableView.register(LoadMoreTableViewCell.self, forCellReuseIdentifier:loadMoreTableViewCell)
        
    }
    
    // Return the number of rows for the table.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemsCount()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    // Provide a cell object for each row.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell
        if (self.isLastCell(indexPath: indexPath) && loadMoreEnabled) {
            cell = tableView.dequeueReusableCell(withIdentifier: loadMoreTableViewCell, for: indexPath)
            loadItems(page: page, per_page: 30)
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: userCellReuseIdentifier, for: indexPath)
            if let userProfileCell = cell as? GitHubUserTableViewCell{
                // Configure the cell’s contents.
                let user = users[indexPath.row]
                userProfileCell.loginLabel.text = user.login
                loadProfileImage(forUser: user, cell: userProfileCell)
            }
            return cell
        }
        return cell
    }
    
    func isLastCell(indexPath: IndexPath) -> Bool {
        return self.itemsCount() - 1 == indexPath.row;
    }
    
    func itemsCount() -> Int {
        return users.count + (loadMoreEnabled ? 1 : 0)
    }
    
    func loadItems(page:Int, per_page:Int) {
        dataCoordinator.loadItems(page: page, per_page: per_page) { (users, error) in
            DispatchQueue.main.async {
                if let users = users {
                    self.users.append(contentsOf: users)
                    var indexPaths = Array<IndexPath>()
                    for i in ((page-1)*per_page)..<((page)*per_page) {
                        indexPaths.append(IndexPath.init(row: i, section: 0))
                    }
                    self.page+=1
                    self.tableView.insertRows(at: indexPaths, with: .automatic)
                }
            }
        }
    }
    
    func loadProfileImage(forUser user:GitHubUser, cell:GitHubUserTableViewCell) {
        guard let avatar_url = user.avatar_url,
              let imageURL = NSURL(string: avatar_url) else {
            return
        }
        let token = imageLoader.loadImage(imageURL as URL) { result in
          do {
            let image = try result.get()
            DispatchQueue.main.async {
              cell.profileImageView.image = image
            }
          } catch {
            print(error)
          }
        }
        cell.onReuse = {
          if let token = token {
            self.imageLoader.cancelLoad(token)
          }
        }
    }
}

