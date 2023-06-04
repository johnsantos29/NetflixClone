//
//  SearchResultsViewController.swift
//  NetflixClone
//
//  Created by John Erick Santos on 4/6/2023.
//

import UIKit

protocol SearchResultsViewControllerDelegate: AnyObject {
    func searchResultsViewControllerDidTapItem(_ viewModel: TitlePreviewViewModel)
}

class SearchResultsViewController: UIViewController {
    public var titles: [TMDBData] = .init()
    
    weak var delegate: SearchResultsViewControllerDelegate?
    
    public let searchResultsCollectionView: UICollectionView = {
        let layoutWidth = (UIScreen.main.bounds.width / 3) - 10
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: layoutWidth, height: 200)
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TMDBDataCollectionViewCell.self, forCellWithReuseIdentifier: TMDBDataCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubview(searchResultsCollectionView)
        
        searchResultsCollectionView.delegate = self
        searchResultsCollectionView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        searchResultsCollectionView.frame = view.bounds
    }
}

extension SearchResultsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TMDBDataCollectionViewCell.identifier, for: indexPath) as? TMDBDataCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configureCollectionViewCell(with: titles[indexPath.row].poster_path ?? "")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        
        guard let titleName = title.original_name ?? title.original_title,
              let overview = title.overview else { return }
        
        APIManager.shared.fetchYoutubeData(query: titleName) { [weak self] results in
            switch results {
            case .success(let youtubeVideo):
                let viewModel = TitlePreviewViewModel(title: titleName, youtubeVideo: youtubeVideo, titleOverview: overview)
                self?.delegate?.searchResultsViewControllerDidTapItem(viewModel)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
