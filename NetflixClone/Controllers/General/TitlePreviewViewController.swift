//
//  TitlePreviewViewController.swift
//  NetflixClone
//
//  Created by John Erick Santos on 4/6/2023.
//

import UIKit
import WebKit

final class TitlePreviewViewController: UIViewController {
    private let webView: WKWebView = {
        let wkWebView = WKWebView()
        wkWebView.translatesAutoresizingMaskIntoConstraints = false
        return wkWebView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.text = "Harry Potter"
        return label
    }()

    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        label.text = "Overview label"
        return label
    }()

    private let downloadButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemRed
        button.setTitle("Download", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(webView)
        view.addSubview(titleLabel)
        view.addSubview(overviewLabel)
        view.addSubview(downloadButton)

        applyTitlePreviewConstraints()
    }
}

// MARK: - Configure

extension TitlePreviewViewController {
    public func configure(with viewModel: TitlePreviewViewModel) {
        titleLabel.text = viewModel.title
        overviewLabel.text = viewModel.titleOverview

        let embedUrlString = "https://youtube.com/embed/\(viewModel.youtubeVideo.id.videoId)"

        guard let url = URL(string: embedUrlString) else {
            return
        }

        webView.load(URLRequest(url: url))
    }
}

// MARK: - Constraints

extension TitlePreviewViewController {
    private func applyTitlePreviewConstraints() {
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.heightAnchor.constraint(equalToConstant: 250),

            titleLabel.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            overviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            overviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            downloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            downloadButton.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 30),
            downloadButton.widthAnchor.constraint(equalToConstant: 140),
            downloadButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
}
