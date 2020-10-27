//
//  ViewController.swift
//  GitHubUsers
//
//  Created by Sergii on 10/26/20.
//

import UIKit

class GitHubUsersListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier:"cellTypeIdentifier")
    }
    
    // Return the number of rows for the table.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 10
    }

    // Provide a cell object for each row.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // Fetch a cell of the appropriate type.
       let cell = tableView.dequeueReusableCell(withIdentifier: "cellTypeIdentifier", for: indexPath)
       
       // Configure the cell’s contents.
       cell.textLabel!.text = "Cell text"
           
       return cell
    }
}

