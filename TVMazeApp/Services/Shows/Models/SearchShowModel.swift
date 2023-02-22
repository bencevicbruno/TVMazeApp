//
//  SearchShowModel.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 21.02.2023..
//

import Foundation

struct SearchShowModel: Identifiable, Hashable {
    let id: Int
    let title: String
    let posterURL: String
    let rating: Double
    let description: String
    let categories: [String]
    
    static func sample(withID id: Int = -1) -> SearchShowModel {
        .init(id: id,
              title: "Search Show #\(id)",
              posterURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/0/0f/Grosser_Panda.JPG/1200px-Grosser_Panda.JPG",
              rating: 10,
              description: "The highly recommended Sample Show just aired! Start watching now! Or don't. You decide. It's up to you...",
              categories: ["Panda", "Bamboo", "Nature"])
    }
}

extension SearchShowModel {
    
    init?(from response: EmbeddedShow) {
        self.id = response.show.id
        self.title = response.show.name
        
        guard let posterURL = response.show.image?.original else { return nil }
        self.posterURL = posterURL
        
        guard let rating = response.show.rating.average else { return nil }
        self.rating = rating
        
        guard let description = response.show.summary else { return nil }
        self.description = description.removingHTML()
        
        self.categories = response.show.genres
    }
}
