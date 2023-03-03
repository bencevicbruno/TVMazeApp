//
//  EpisodesResponse.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 01.03.2023..
//

import Foundation

struct EpisodeResponse: Decodable {
    let id: Int
    let name: String
    let season: Int
    let number: Int
    let airdate: String
    let rating: Rating
    let image: ImageResponse?
    let summary: String?
    
    struct Rating: Decodable {
        let average: Double?
    }
}
