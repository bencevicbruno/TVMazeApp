//
//  View+LocationReader.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 20.02.2023..
//

import SwiftUI

extension View {
    
    func readLocation(into locationBinding: Binding<CGPoint>) -> some View {
        self.background {
            GeometryReader { proxy in
                Color.clear
                    .preference(key: LocationPreferenceKey.self, value: proxy.frame(in: .global).origin)
            }
        }
        .onPreferenceChange(LocationPreferenceKey.self) { location in
            locationBinding.wrappedValue = location
        }
    }
}

fileprivate struct LocationPreferenceKey: PreferenceKey {
    
    static var defaultValue: CGPoint = .zero
    
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {}
}
