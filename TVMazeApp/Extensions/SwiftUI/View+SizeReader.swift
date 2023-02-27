//
//  View+SizeReader.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 14.11.2022..
//

import SwiftUI

extension View {
    
    func readSize(into sizeBinding: Binding<CGSize>) -> some View {
        self.background(
            GeometryReader { proxy in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: proxy.size)
            }
        )
        .onPreferenceChange(SizePreferenceKey.self) { size in
            sizeBinding.wrappedValue = size
        }
    }
}

fileprivate struct SizePreferenceKey: PreferenceKey {
    
    static var defaultValue: CGSize = .zero
    
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}
