//
//  Tv.swift
//  NetflixClone
//
//  Created by John Erick Santos on 3/6/2023.
//

import Foundation

struct TrendingTvsResponse: Codable {
    let results: [Tv]
}

struct Tv: Codable {
    let id: Int
    let media_type: String?
    let original_name: String?
    let poster_path: String?
    let overview: String?
    let vote_count: Int
    let vote_average: Double
    let release_date: String?
}
