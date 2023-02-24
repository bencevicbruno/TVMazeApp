//
//  ShowCastModel.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 24.02.2023..
//

import Foundation

struct ShowCastModel {
    let cast: [CastMemberModel]
    
    static func sample() -> ShowCastModel {
        .init(cast: (1...0).map { .sample(withID: $0) })
    }
}

extension ShowCastModel {
    
    init?(from response: SingleShowResponse) {
        guard let cast = response.embedded?.cast else { return nil }
        
        let potentialCast: [CastMemberModel?] = cast.map { member in
            guard let avatarURL = member.person.image?.original else { return nil }
            guard let roleName = member.character?.name else { return nil }
            
            return .init(id: member.person.id,
                         name: member.person.name,
                         avatarURL: avatarURL,
                         roleName: roleName)
        }
        
        self.cast = potentialCast.compactMap { $0 }.uniqueOnly
    }
}
