//
//  Float+.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 13.02.2023..
//

import Foundation

extension Float {
    
    var isInteger: Bool {
        Int(exactly: Double(self)) != nil
    }
}
