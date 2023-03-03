//
//  Interpolator.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 24.02.2023..
//

import Foundation

protocol Interpolator: Hashable {
    
    func interpolate(_ value: CGFloat) -> CGFloat
}
