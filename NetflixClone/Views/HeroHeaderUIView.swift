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

    private let playButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Play", for: .normal)
        // TODO: change color
        button.layer.borderColor = UIColor.secondarySystemFill.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        return button
    }()

    private let downloadButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Download", for: .normal)
        // TODO: change color
        button.layer.borderColor = UIColor.secondarySystemFill.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        return button
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(heroImageView)

        // add a fading gradient layer
        // on the view
        addGradient()

        addSubview(playButton)
        addSubview(downloadButton)

        applyConstraints()
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

extension HeroHeaderUIView {
    public func configureHeroHeaderView(with viewModel: TitleViewModel) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(viewModel.posterURL)") else {
            return
        }

        heroImageView.sd_setImage(with: url)
    }

    private func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.systemBackground.cgColor,
        ]
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
    }

    private func applyConstraints() {
        NSLayoutConstraint.activate([
            playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 70),
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            playButton.widthAnchor.constraint(equalToConstant: 120),

            downloadButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -70),
            downloadButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            downloadButton.widthAnchor.constraint(equalToConstant: 120),
        ])
    }
}
