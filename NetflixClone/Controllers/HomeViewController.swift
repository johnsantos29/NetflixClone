//
//  HomeViewController.swift
//  NetflixClone
//
//  Created by John Erick Santos on 28/5/2023.
//

import UIKit

class HomeViewController: UIViewController {
    private let homeFeedTable: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forHeaderFooterViewReuseIdentifier: "cell")
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(homeFeedTable)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }
}
