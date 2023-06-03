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

enum APIError: Error {
    case failedToGetTrendingMovies
}

final class APIManager {
    static let shared = APIManager()

    func fetchTMDBData(urlString url: String, completion: @escaping (Result<[TMDBData], Error>) -> Void) {
        guard let url = URL(string: url) else { return }

        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }

            do {
                let results = try JSONDecoder().decode(TMDBApiResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }
}
