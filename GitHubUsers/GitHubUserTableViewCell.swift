//
//  GitHubUserTableViewCell.swift
//  GitHubUsers
//
//  Created by Sergii on 10/28/20.
//

import UIKit

class GitHubUserTableViewCell : UITableViewCell {
    var profileImageView: UIImageView
    var loginLabel : UILabel
    var onReuse: () -> Void = {}
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        profileImageView = UIImageView()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        loginLabel = UILabel()
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        initViews()
        onReuse()
        profileImageView.image = nil
        loginLabel.text = nil
    }
    
    func initViews() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(loginLabel)
        NSLayoutConstraint.activate([
            profileImageView.widthAnchor.constraint(equalToConstant: 40),
            profileImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            profileImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            loginLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            loginLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 10)
        ])
    }
    
}
