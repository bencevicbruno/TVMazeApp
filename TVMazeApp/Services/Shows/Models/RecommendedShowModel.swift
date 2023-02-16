//
//  RecommendedShowModel.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 15.02.2023..
//

import Foundation

struct RecommendedShowModel: Identifiable, Hashable {
    let id: Int
    let title: String
    let posterURL: String
    let rating: Double
    
    static func sample(withID id: Int = -1) -> RecommendedShowModel {
        .init(id: id,
              title: "Sample Recommended Show",
              posterURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/0/0f/Grosser_Panda.JPG/1200px-Grosser_Panda.JPG",
              rating: 10)
    }
}

extension RecommendedShowModel {
    
    init?(from response: EmbeddedShow) {
        self.id = response.show.id
        self.title = response.show.name
        
        guard let posterURL = response.show.image?.original else { return nil }
        self.posterURL = posterURL
        
        guard let rating = response.show.rating.average else { return nil }
        self.rating = rating
    }
}
