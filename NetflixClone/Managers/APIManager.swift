//
//  APIManager.swift
//  NetflixClone
//
//  Created by John Erick Santos on 1/6/2023.
//

import Foundation

struct Constants {
    static let BASE_URL = "https://api.themoviedb.org"
    static let API_KEY = "4b44fbc99966d38eddfd056750a02462"
}

final class APIManager {
    static let shared = APIManager()

    func getTrendingMovies(completion: @escaping (String) -> Void) {
        let trendingURL = "\(Constants.BASE_URL)/3/trending/all/day?api_key=\(Constants.API_KEY)"

        guard let url = URL(string: trendingURL) else { return }

        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }

            do {
                let results = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                print(results)
            } catch {
                print(error.localizedDescription)
            }
        }

        task.resume()
    }
}
