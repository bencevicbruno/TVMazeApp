//
//  UIColor+.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 13.02.2023..
//

import UIKit

extension UIColor {
    
    static let tvMazeBlack = UIColor(hex: 0x161616)
    static let tvMazeWhite = UIColor(hex: 0xFEFEFE)
    static let tvMazeYellow = UIColor(hex: 0xFCC603)
    static let tvMazeDarkGray = UIColor(hex: 0x1C1B1B)
    static let tvMazeGray = UIColor(hex: 0x555555)
    static let tvMazeLightGray = UIColor(hex: 0x999797)
}

private extension UIColor {
    
    convenience init(hex: UInt32) {
        let red = (hex >> 16) & 0xFF
        let green = (hex >> 8) & 0xFF
        let blue = hex & 0xFF
        
        self.init(red: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: 1.0)
    }
}
