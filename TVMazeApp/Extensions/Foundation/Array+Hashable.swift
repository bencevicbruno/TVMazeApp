//
//  Array+Hashable.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 15.02.2023..
//

import Foundation

extension Array where Element: Hashable {
    
    var uniqueOnly: Self {
        return Array(Set(self))
    }
}
