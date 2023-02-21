//
//  CastMemberModel.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 20.02.2023..
//

import Foundation

struct CastMemberModel: Identifiable, Hashable {
    let id: Int
    let name: String
    let avatarURL: String
    let roleName: String
    
    static func sample(withID id: Int = -1) -> CastMemberModel {
        .init(id: id,
              name: "Johny Bravo",
              avatarURL: "https://c1-ebgames.eb-cdn.com.au/merchandising/images/packshots/680a399d0cf94d0b97a1c7791bcdc0e4_Large.jpg",
              roleName: "Himself")
    }
}
