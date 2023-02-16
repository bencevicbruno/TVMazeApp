//
//  CGRect+.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 16.02.2023..
//

import CoreGraphics

extension CGRect {
    
    func reducingHeight(_ height: CGFloat) -> CGRect {
        .init(x: self.minX, y: self.minY, width: self.width, height: self.height - height)
    }
}
