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

fileprivate struct LocationPreferenceKey: PreferenceKey {
    
    static var defaultValue: CGPoint = .zero
    
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {}
}

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

fileprivate struct RectPreferenceKey: PreferenceKey {
    
    static var defaultValue: CGRect = .zero
    
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {}
}

extension View {
    
    func readRect(into rectBinding: Binding<CGRect>) -> some View {
        self.background {
            GeometryReader { proxy in
                Color.clear
                    .preference(key: RectPreferenceKey.self, value: proxy.frame(in: .global))
            }
        }
        .onPreferenceChange(RectPreferenceKey.self) { rect in
            rectBinding.wrappedValue = rect
        }
    }
}
