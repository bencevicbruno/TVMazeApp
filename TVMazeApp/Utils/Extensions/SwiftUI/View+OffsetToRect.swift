//
//  View+OffsetToRect.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 20.02.2023..
//

import SwiftUI

struct OffsetToRectModifier: ViewModifier {
    
    private let rect: CGRect?
    
    @State private var currentRect: CGRect = .zero
    
    init(rect: CGRect?) {
        self.rect = rect
    }
    
    func body(content: Content) -> some View {
        content
            .offset(x: rect == nil ? 0 : (rect!.minX - currentRect.minX),
                    y: rect == nil ? 0 : (rect!.minY - currentRect.minY))
            .readRect(into: $currentRect)
    }
}

extension View {
    
    func offset(to rect: CGRect?) -> some View {
        self.modifier(OffsetToRectModifier(rect: rect))
    }
}
