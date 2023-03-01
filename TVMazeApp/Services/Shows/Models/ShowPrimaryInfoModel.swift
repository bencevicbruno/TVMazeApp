//
//  ShowPrimaryInfoModel.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 01.03.2023..
//

import UIKit

struct ShowPrimaryInfoModel: Identifiable, Hashable {
    let id: Int
    let title: String
    let poster: UIImage
    let description: String
    
    init(from model: RecommendedShowModel) {
        self.id = model.id
        self.title = model.title
        self.poster = CacheService.instance.getImage(for: model.posterURL) ?? UIImage(named: "placeholder_panda")!
        self.description = model.description
    }
    
    init(from model: ScheduledShowModel) {
        self.id = model.id
        self.title = model.title
        self.poster = CacheService.instance.getImage(for: model.posterURL) ?? UIImage(named: "placeholder_panda")!
        self.description = model.description
    }
    
    init(from model: FavoriteShowModel) {
        self.id = model.id
        self.title = model.title
        self.poster = CacheService.instance.getImage(for: model.posterURL) ?? UIImage(named: "placeholder_panda")!
        self.description = model.description
    }
    
    init(from model: SearchShowModel) {
        self.id = model.id
        self.title = model.title
        self.poster = CacheService.instance.getImage(for: model.posterURL) ?? UIImage(named: "placeholder_panda")!
        self.description = model.description
    }
}
