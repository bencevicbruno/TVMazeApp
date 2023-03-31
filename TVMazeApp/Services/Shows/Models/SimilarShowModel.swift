//
//  SimilarShowModel.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 29.03.2023..
//

import Foundation

struct SimialarShowModel: Identifiable, Hashable {
    let id: Int
    let title: String
    let posterURL: String?
    let rating: Double?
    let description: String?
    
    static func sample(withID id: Int = -1) -> SimialarShowModel {
        .init(id: id,
              title: "Sample Similar Show",
              posterURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/0/0f/Grosser_Panda.JPG/1200px-Grosser_Panda.JPG",
              rating: 10,
              description: "Might be the same, might not, idk...")
    }
}

extension SimialarShowModel {
    
    init?(from response: SingleShowResponse) {
        self.id = response.id
        self.title = response.name
        self.posterURL = response.image?.original
        self.rating = response.rating.average
        self.description = response.summary?.removingHTML()
    }
}
