//
//  Int+.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 15.02.2023..
//

import Foundation

extension Int {
    
    var asDoubleDigit: String {
        return self > 10 ? "\(self)" : "0\(self)"
    }
}
