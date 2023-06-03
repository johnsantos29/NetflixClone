//
//  Movie.swift
//  NetflixClone
//
//  Created by John Erick Santos on 1/6/2023.
//

import Foundation

struct TMDBApiResponse: Codable {
    let results: [TMDBData]
}

struct TMDBData: Codable {
    let id: Int
    let media_type: String?
    let original_title: String?
    let original_name: String?
    let poster_path: String?
    let overview: String?
    let vote_count: Int
    let vote_average: Double
    let release_date: String?
}
