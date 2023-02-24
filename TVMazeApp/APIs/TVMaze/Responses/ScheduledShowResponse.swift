//
//  ScheduledShowResponse.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 24.02.2023..
//

import Foundation

struct ScheduledShowResponse: Decodable {
    let airdate: String
    let embedded: EmbeddedShow
    
    struct EmbeddedShow: Decodable {
        let show: SingleShowResponse
    }
    
    enum CodingKeys: String, CodingKey {
        case airdate
        case embedded = "_embedded"
    }
}
