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
    static let YT_API_KEY = "AIzaSyA8EPcyq2_6aUjkFi658s2iEev-baQ4Z4o"
    static let YT_BASE_URL = "https://youtube.googleapis.com/youtube/v3/search?"
}

enum APIError: Error {
    case failedToGetTMDBData
    case failedToGetYTData
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
                completion(.failure(APIError.failedToGetTMDBData))
            }
        }
        
        task.resume()
    }
    
    func fetchYoutubeData(query: String, completion: @escaping (Result<YoutubeVideo, Error>) -> Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
              let url = URL(string: "\(Constants.YT_BASE_URL)q=\(query)&key=\(Constants.YT_API_KEY)")
        else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let results = try JSONDecoder().decode(YoutubeApiResponse.self, from: data)
                completion(.success(results.items[0]))
            } catch {
                completion(.failure(APIError.failedToGetYTData))
            }
        }
        
        task.resume()
    }
}
