//
//  HeroHeaderUIView.swift
//  NetflixClone
//
//  Created by John Erick Santos on 30/5/2023.
//

import UIKit

final class HeroHeaderUIView: UIView {
    private let heroImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "heroImage")
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(heroImageView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        heroImageView.frame = bounds
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
}
