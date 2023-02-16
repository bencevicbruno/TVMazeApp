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
    let posterURL: String
    let airdate: Date
    let categories: [String]
    
    static func sample(withID id: Int = -1) -> ScheduledShowModel {
        .init(id: id,
              title: "Sample Scheduled Show",
              posterURL: "https://geographical.co.uk/wp-content/uploads/panda1200-1.jpg",
              airdate: .distantPast,
              categories: ["Cute", "Kawaii"])
    }
}

extension ScheduledShowModel {
    
    init?(from response: ScheduledShowResponse) {
        self.id = response.embedded.show.id
        self.title = response.embedded.show.name
        
        guard let posterURL = response.embedded.show.image?.original else { return nil }
        self.posterURL = posterURL
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        guard let airdate = dateFormatter.date(from: response.airdate) else { return nil }
        self.airdate = airdate
        self.categories = response.embedded.show.genres
    }
}
