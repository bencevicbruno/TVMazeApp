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
    let posterURL: String?
    let rating: Double?
    let description: String?
    
    static func sample(withID id: Int = -1) -> RecommendedShowModel {
        .init(id: id,
              title: "Sample Recommended Show",
              posterURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/0/0f/Grosser_Panda.JPG/1200px-Grosser_Panda.JPG",
              rating: 10,
              description: "The highly recommended Sample Show just aired! Start watching now! Or don't. You decide. It's up to you...")
    }
}

extension RecommendedShowModel {
    
    init?(from response: SingleShowResponse) {
        self.id = response.id
        self.title = response.name
        self.posterURL = response.image?.original
        self.rating = response.rating.average
        self.description = response.summary?.removingHTML()
    }
}
