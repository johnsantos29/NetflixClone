//
//  TMDBDataCollectionViewCell.swift
//  NetflixClone
//
//  Created by John Erick Santos on 3/6/2023.
//

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
