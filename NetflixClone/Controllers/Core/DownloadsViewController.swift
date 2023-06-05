//
//  DownloadsViewController.swift
//  NetflixClone
//
//  Created by John Erick Santos on 28/5/2023.
//

import UIKit

class DownloadsViewController: UIViewController {
    private var titles: [TitleItem] = .init()
    
    private let downloadedTable: UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(downloadedTable)
        title = "Downloads"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        downloadedTable.delegate = self
        downloadedTable.dataSource = self
        
        fetchTMDBFromDB()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        downloadedTable.frame = view.bounds
    }
}

// MARK: - CoreData

extension DownloadsViewController {
    private func fetchTMDBFromDB() {
        DataPersistenceManager.shared.fetchTMDBDataFromDB { [weak self] result in
            switch result {
            case .success(let titles):
                self?.titles = titles
                DispatchQueue.main.async {
                    self?.downloadedTable.reloadData()
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
}

extension DownloadsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
        }
        
        let title = titles[indexPath.row]
        cell.configure(with: TitleViewModel(
            titleName: title.original_title ?? title.original_name ?? "Unknown title",
            posterURL: title.poster_path ?? ""))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}
