//
//  SingleShowResponse.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 24.02.2023..
//

import Foundation

struct SingleShowResponse: Decodable {
    let id: Int
    let name: String
    let genres: [String]
    let rating: Rating
    let image: ImageResponse?
    let summary: String?
    let embedded: CastResponse?
    
    struct Rating: Decodable {
        let average: Double?
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, genres, rating, image, summary
        case embedded = "_embedded"
    }
}
