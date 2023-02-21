//
//  Text+.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 12.02.2023..
//

import SwiftUI

extension Text {
    
    func style(_ font: Font, color: Color = .black, alignment: TextAlignment = .leading) -> some View {
        self.font(font)
            .foregroundColor(color)
            .multilineTextAlignment(alignment)
    }
}
