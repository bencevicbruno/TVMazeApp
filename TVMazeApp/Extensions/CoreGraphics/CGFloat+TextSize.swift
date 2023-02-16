//
//  CGFloat+TextSize.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 12.02.2023..
//

import UIKit

extension CGFloat {
    
    static var textSizeDisplay: CGFloat {
        UIScreen.isSmall ? 30 : 32
    }
    
    static var textSizeHeader1: CGFloat {
        UIScreen.isSmall ? 20 : 24
    }
    
    static var textSizeHeader2: CGFloat {
        UIScreen.isSmall ? 20 : 22
    }
    
    static var textSizeLargeBody: CGFloat {
        UIScreen.isSmall ? 18 : 20
    }
    
    static var textSizeBody: CGFloat {
        UIScreen.isSmall ? 16 : 18
    }
    
    static var textSizeCaption: CGFloat {
        UIScreen.isSmall ? 14 : 16
    }
    
    static var textSizeSmallCaption: CGFloat {
        UIScreen.isSmall ? 12 : 14
    }
    
    static var textSizeLabel: CGFloat {
        UIScreen.isSmall ? 10 : 12
    }
    
    static var textSizeSmallLabel: CGFloat {
        UIScreen.isSmall ? 8 : 10
    }
}
