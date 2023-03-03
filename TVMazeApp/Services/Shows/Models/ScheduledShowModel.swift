//
//  ScheduledShowModel.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 15.02.2023..
//

import Foundation

struct ScheduledShowModel: Identifiable, Hashable {
    let id: Int
    let title: String
    let posterURL: String?
    let categories: [String]
    let description: String?
    
    static func sample(withID id: Int = -1) -> ScheduledShowModel {
        .init(id: id,
              title: "Sample Scheduled Show",
              posterURL: "https://geographical.co.uk/wp-content/uploads/panda1200-1.jpg",
              categories: ["Cute", "Kawaii"],
              description: "The highly recommended Sample Show just aired! Start watching now! Or don't. You decide. It's up to you...")
    }
}

extension ScheduledShowModel {
    
    init?(from response: ScheduledShowResponse) {
        self.id = response.embedded.show.id
        self.title = response.embedded.show.name
        self.posterURL = response.embedded.show.image?.original
        self.categories = response.embedded.show.genres
        self.description = response.embedded.show.summary?.removingHTML()
    }
}
