//
//  ViewController.swift
//  GitHubUsers
//
//  Created by Sergii on 10/26/20.
//

import UIKit

class LoadMoreTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initActivityIndicator()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        initActivityIndicator()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initActivityIndicator() {
        let activityIndicatorView = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.medium)
        activityIndicatorView.startAnimating()
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(activityIndicatorView)
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            activityIndicatorView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            activityIndicatorView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
    }
}

class GitHubUsersListTableViewController: UITableViewController {
    let userCellReuseIdentifier = "userCellReuseIdentifier"
    let loadMoreTableViewCell = "loadMoreTableViewCell"
    var users = Array<String>()
    var loadMoreEnabled:Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier:userCellReuseIdentifier)
        self.tableView.register(LoadMoreTableViewCell.self, forCellReuseIdentifier:loadMoreTableViewCell)
        
    }
    
    // Return the number of rows for the table.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemsCount()
    }

    // Provide a cell object for each row.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell
        if (self.isLastCell(indexPath: indexPath) && loadMoreEnabled) {
            cell = tableView.dequeueReusableCell(withIdentifier: loadMoreTableViewCell, for: indexPath)
            loadMore(count: 30, offset: users.count)
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: userCellReuseIdentifier, for: indexPath)
            // Configure the cell’s contents.
            cell.textLabel!.text = users[indexPath.row]
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
    
    func loadMore(count:Int, offset:Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            var indexPaths = Array<IndexPath>()
            for i in offset..<(offset+count) {
                self.users.append("\(i)")
                indexPaths.append(IndexPath.init(row: i, section: 0))
            }
            self.tableView.insertRows(at: indexPaths, with: .automatic)
        }
    }
}

