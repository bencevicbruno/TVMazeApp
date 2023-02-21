//
//  FavoriteShowModel.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 15.02.2023..
//

import Foundation

struct FavoriteShowModel: Identifiable, Hashable {
    let id: Int
    let title: String
    let posterURL: String
    let description: String
    
    static func sample(withID id: Int = -1) -> FavoriteShowModel {
        .init(id: id,
              title: "My favorite bamboo eating panda",
              posterURL: "https://howchoo.com/media/ym/m3/od/brown-panda-minecraft-rare-spawn.png?width=1440&auto=webp&quality=70&crop=4:3,smart",
              description: "It's just a panda eating some bamboo, that is all.")
    }
}

extension FavoriteShowModel {
    
    init?(from response: SingleShowResponse) {
        self.id = response.id
        self.title = response.name
        
        guard let posterURL = response.image?.original else { return nil }
        self.posterURL = posterURL
        
        guard let description = response.summary else { return nil }
        self.description = description.removingHTML()
    }
}
