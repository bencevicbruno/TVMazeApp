//
//  View+RectReader.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 20.02.2023..
//

import SwiftUI

fileprivate struct RectPreferenceKey: PreferenceKey {
    
    static var defaultValue: CGRect = .zero
    
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {}
}

extension View {
    
    func readRect(into rectBinding: Binding<CGRect>, _ rectModifier: ((CGRect) -> CGRect)? = nil) -> some View {
        self.background {
            GeometryReader { proxy in
                Color.clear
                    .preference(key: RectPreferenceKey.self, value: rectModifier?(proxy.frame(in: .global)) ?? proxy.frame(in: .global))
            }
        }
        .onPreferenceChange(RectPreferenceKey.self) { rect in
            rectBinding.wrappedValue = rect
        }
    }
}
