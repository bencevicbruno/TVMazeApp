//
//  OffsetAdjustableTitle.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 20.02.2023..
//

import SwiftUI

struct OffsetAdjustableTitle: View {
    
    private let title: String
    @Binding private var offset: CGPoint
    private let fontSizeInterpolator: SlopedStepRange
    private let leadingPaddingInterpolator: SlopedStepRange
    
    
    init(_ title: String, offset: Binding<CGPoint>, firstThreshold: CGFloat, secondThreshold: CGFloat) {
        self.title = title
        self._offset = offset.readOnly
        
        self.fontSizeInterpolator = .init(firstPoint: firstThreshold, firstValue: .textSizeDisplay, secondPoint: secondThreshold, secondValue: .textSizeLargeBody)
        
        self.leadingPaddingInterpolator = .init(firstPoint: firstThreshold, firstValue: 16, secondPoint: secondThreshold, secondValue: (UIScreen.width - title.getWidth(using: .boldBodyDefault)) / 2)
    }
    
    var body: some View {
        Text(title)
            .style(.init(UIFont.merriweatherBold(size: fontSizeInterpolator.interpolate(value: -offset.y))), color: .tvMazeWhite)
            .padding(.vertical, 8)
            .padding(.leading, leadingPaddingInterpolator.interpolate(value: -offset.y))
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct OffsetAdjustableTitle_Previews: PreviewProvider {
    
    static var previews: some View {
        OffsetAdjustableTitle("Home", offset: .constant(.zero), firstThreshold: 100, secondThreshold: 200)
            .background(.black)
    }
}
