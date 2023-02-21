//
//  View+Frame.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 13.02.2023..
//

import SwiftUI

extension View {
    
    func frame(size: CGFloat, alignment: Alignment = .center) -> some View {
        self.frame(width: size, height: size, alignment: alignment)
    }
    
    func frameAsIcon(imageSize: CGFloat = 24, iconSize: CGFloat = 40) -> some View {
        self.frame(size: imageSize)
            .frame(size: iconSize)
    }
}
