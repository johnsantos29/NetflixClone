//
//  TMDBDataCollectionViewCell.swift
//  NetflixClone
//
//  Created by John Erick Santos on 3/6/2023.
//

import SDWebImage
import UIKit

final class TMDBDataCollectionViewCell: UICollectionViewCell {
    static let identifier = "TMDBDataCollectionViewCell"

    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(posterImageView)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        posterImageView.frame = contentView.bounds
    }
}

// MARK: - SDWebImage

extension TMDBDataCollectionViewCell {
    public func configureCollectionViewCell(with imagePath: String) {
        let fullImagePath = "https://image.tmdb.org/t/p/w500\(imagePath)"

        guard let url = URL(string: fullImagePath) else { return }
        posterImageView.sd_setImage(with: url, completed: nil)
    }
}
