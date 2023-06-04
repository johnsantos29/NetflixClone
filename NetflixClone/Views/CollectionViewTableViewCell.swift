//
//  CollectionViewTableViewCell.swift
//  NetflixClone
//
//  Created by John Erick Santos on 29/5/2023.
//

import UIKit

protocol CollectionViewTableViewCellDelegate: AnyObject {
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: TitlePreviewViewModel)
}

class CollectionViewTableViewCell: UITableViewCell {
    static let identifier = "CollectionViewTableViewCell"
    
    weak var delegate: CollectionViewTableViewCellDelegate?
    
    private var titles: [TMDBData] = .init()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 200)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TMDBDataCollectionViewCell.self, forCellWithReuseIdentifier: TMDBDataCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemPink
        
        contentView.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
}

// MARK: - Configure

extension CollectionViewTableViewCell {
    public func configureTableViewCell(with titles: [TMDBData]) {
        self.titles = titles
        
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
}

extension CollectionViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TMDBDataCollectionViewCell.identifier,
            for: indexPath) as? TMDBDataCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        
        guard let imagePath = titles[indexPath.row].poster_path else {
            return UICollectionViewCell()
        }
        
        cell.configureCollectionViewCell(with: imagePath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        guard let titleName = title.original_name ?? title.original_title,
              let overview = title.overview
        else {
            return
        }
        
        APIManager.shared.fetchYoutubeData(query: titleName + " trailer") { [weak self] result in
            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let youtubeVideo):
                strongSelf.delegate?.collectionViewTableViewCellDidTapCell(
                    strongSelf,
                    viewModel: TitlePreviewViewModel(
                        title: titleName,
                        youtubeVideo: youtubeVideo,
                        titleOverview: overview))
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
}
