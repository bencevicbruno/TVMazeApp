//
//  ShowEpisodeModel.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 01.03.2023..
//

import Foundation

struct ShowEpisodeModel: Identifiable {
    let id: Int
    let title: String
    let rating: Double
    let season: Int
    let episode: Int
    let airdate: Date
    let description: String
    let imageURL: String
    
    static func sample(withID id: Int = -1) -> ShowEpisodeModel {
        .init(id: id,
              title: "Title #\(id)",
              rating: 5,
              season: 1,
              episode: 1,
              airdate: .now,
              description: "lorem ipsum nesta nesta jedna duga cesta koja vodi tamo negdje preko duge",
              imageURL: "https://upload.wikimedia.org/wikipedia/commons/4/49/Koala_climbing_tree.jpg")
    }
}

extension ShowEpisodeModel {
    
    init?(from response: EpisodeResponse) {
        self.id = response.id
        self.title = response.name
        
        guard let rating = response.rating.average else { return nil }
        self.rating = rating
        
        self.season = response.season
        self.episode = response.number
        
//        guard let airdate = response.airdate else { return nil }
        self.airdate = .now//airdate
        self.description = response.summary?.removingHTML() ?? "No description"
        self.imageURL = response.image.original
    }
}
