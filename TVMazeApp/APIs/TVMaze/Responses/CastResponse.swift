//
//  CastResponse.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 24.02.2023..
//

import Foundation

struct CastResponse: Decodable {
    let cast: [CastMember]
    
    struct CastMember: Decodable {
        let person: Person
        let character: Character?
        
        struct Person: Decodable {
            let id: Int
            let name: String
            let image: ImageResponse?
        }

        struct Character: Decodable {
            let id: Int
            let name: String
        }
    }
}
