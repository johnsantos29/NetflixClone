//
//  YoutubeVideo.swift
//  NetflixClone
//
//  Created by John Erick Santos on 4/6/2023.
//

import Foundation

struct YoutubeApiResponse: Codable {
    let items: [YoutubeVideo]
}

struct YoutubeVideo: Codable {
    let id: VideoId
}

struct VideoId: Codable {
    let kind: String
    let videoId: String
}
