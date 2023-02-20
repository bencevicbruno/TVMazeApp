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
    
    
    init(_ title: String, offset: Binding<CGPoint>) {
        self.title = title
        self._offset = offset.readOnly
    }
    
    var body: some View {
        Text(title)
            .style(.init(UIFont.merriweatherBold(size: Self.fontSizeInterpolator.interpolate(value: -offset.y))), color: .tvMazeWhite)
            .padding(.vertical, 8)
            .padding(.leading, Self.leadingPaddingInterpolator(title).interpolate(value: -offset.y))
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    static let firstThreshold: CGFloat = UIScreen.height / 2
    static let secondThreshold: CGFloat = UIScreen.height * 3 / 4
    
    static let fontSizeInterpolator = SlopedStepRange(
        firstPoint: Self.firstThreshold,
        firstValue: .textSizeDisplay,
        secondPoint: Self.secondThreshold,
        secondValue: .textSizeLargeBody)
    
    static func leadingPaddingInterpolator(_ title: String) -> SlopedStepRange {
        SlopedStepRange(firstPoint: Self.firstThreshold,
                        firstValue: 16,
                        secondPoint: Self.secondThreshold,
                        secondValue: (UIScreen.width - title.getWidth(using: .boldBodyDefault)) / 2)
    }
}

struct OffsetAdjustableTitle_Previews: PreviewProvider {
    
    static var previews: some View {
        OffsetAdjustableTitle("Home", offset: .constant(.zero))
            .background(.black)
    }
}
