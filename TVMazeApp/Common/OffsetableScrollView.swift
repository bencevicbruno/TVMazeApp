//
//  OffsettableScrollView.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 12.02.2023..
//

import SwiftUI

struct OffsettableScrollView<T: View>: View {
    
    let axes: Axis.Set
    let showsIndicator: Bool
    @Binding var offset: CGPoint
    let content: T
    
    init(axes: Axis.Set = .vertical,
         showsIndicator: Bool = true,
         offset: Binding<CGPoint> = .constant(.zero),
         @ViewBuilder content: () -> T) {
        self.axes = axes
        self.showsIndicator = showsIndicator
        self._offset = offset
        self.content = content()
    }
    
    var body: some View {
        ScrollView(axes, showsIndicators: showsIndicator) {
            GeometryReader { proxy in
                Color.clear.preference(
                    key: OffsetPreferenceKey.self,
                    value: proxy.frame(
                        in: .named("ScrollViewOrigin")
                    ).origin
                )
            }
            .frame(width: 0, height: 0)
            
            content
        }
        .coordinateSpace(name: "ScrollViewOrigin")
        .onPreferenceChange(OffsetPreferenceKey.self) { offset in
            withAnimation {
                self.offset = offset
            }
        }
    }
}

private struct OffsetPreferenceKey: PreferenceKey {
    
    static var defaultValue: CGPoint = .zero
    
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) { }
}
