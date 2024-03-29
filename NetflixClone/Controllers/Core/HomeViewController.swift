//
//  HomeViewController.swift
//  NetflixClone
//
//  Created by John Erick Santos on 28/5/2023.
//

import UIKit

enum Section: Int {
    case TrendingMovie = 0
    case TrendingTv = 1
    case Popular = 2
    case Upcoming = 3
    case TopRated = 4
}

class HomeViewController: UIViewController {
    private var headerView: HeroHeaderUIView?
    
    private let homeFeedTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return table
    }()
    
    let sectionTitles: [String] = ["Trending Movies", "Trending tv", "Popular", "Upcoming Movies", "Top Rated"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubview(homeFeedTable)
        
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        
        configureNavBar()
        
        headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        homeFeedTable.tableHeaderView = headerView
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }
}

// MARK: - Configure

extension HomeViewController {
    private func configureNavBar() {
        // left nav item
        var image = UIImage(named: "netflixLogo")
        image = image?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        
        // right nav items
        let personImage = UIImage(systemName: "person")
        let playImage = UIImage(systemName: "play.rectangle")
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: personImage, style: .done, target: self, action: nil),
            UIBarButtonItem(image: playImage, style: .done, target: self, action: nil),
        ]
        
        navigationController?.navigationBar.tintColor = .label
    }
}

// MARK: - Table View Delegate and DataSource

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(
            x: header.bounds.origin.x + 20,
            y: header.bounds.origin.y,
            width: 100,
            height: header.bounds.height)
        header.textLabel?.textColor = .label
        header.textLabel?.text = header.textLabel?.text?.capitalizeFirstLetter()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CollectionViewTableViewCell.identifier,
            for: indexPath) as? CollectionViewTableViewCell
        else {
            return UITableViewCell()
        }
        
        let trendingMovieURL = "\(Constants.BASE_URL)/3/trending/movie/day?api_key=\(Constants.API_KEY)"
        let trendingTvURL = "\(Constants.BASE_URL)/3/trending/tv/day?api_key=\(Constants.API_KEY)"
        let popularURL = "\(Constants.BASE_URL)/3/movie/popular?api_key=\(Constants.API_KEY)&language=en-US&page=1"
        let upcomingURL = "\(Constants.BASE_URL)/3/movie/upcoming?api_key=\(Constants.API_KEY)&language=en-US&page=1"
        let topRatedURL = "\(Constants.BASE_URL)/3/movie/top_rated?api_key=\(Constants.API_KEY)&language=en-US&page=1"
        var urlString: String
        
        switch indexPath.section {
        case Section.TrendingMovie.rawValue:
            urlString = trendingMovieURL
        case Section.TrendingTv.rawValue:
            urlString = trendingTvURL
        case Section.Popular.rawValue:
            urlString = popularURL
        case Section.Upcoming.rawValue:
            urlString = upcomingURL
        case Section.TopRated.rawValue:
            urlString = topRatedURL
        default:
            return UITableViewCell()
        }
        
        cell.delegate = self
        
        APIManager.shared.fetchTMDBData(urlString: urlString) { [weak self] results in
            switch results {
            case .success(let titles):
                cell.configureTableViewCell(with: titles)
                
                let randomTitle = titles.randomElement()
                guard let titleName = randomTitle?.original_title ?? randomTitle?.original_name,
                      let posterUrl = randomTitle?.poster_path
                else {
                    return
                }
                
                let titleViewModel = TitleViewModel(titleName: titleName, posterURL: posterUrl)
                self?.headerView?.configureHeroHeaderView(with: titleViewModel)
                
            case .failure(let error):
                print(error)
            }
        }
        
        return cell
    }
    
    // TODO: Fix heights
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    // delegate method to hide the navigation bar when scrolling down
    // and show navigation bar when at the top
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
}

extension HomeViewController: CollectionViewTableViewCellDelegate {
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: TitlePreviewViewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
