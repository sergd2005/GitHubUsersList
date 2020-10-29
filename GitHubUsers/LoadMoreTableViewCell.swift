//
//  LoadMoreTableViewCell.swift
//  GitHubUsers
//
//  Created by Sergii on 10/28/20.
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
