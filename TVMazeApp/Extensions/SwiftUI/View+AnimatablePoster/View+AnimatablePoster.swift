//
//  View+AnimatablePoster.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 20.02.2023..
//

import SwiftUI

extension View {
    
    func animatablePoster(id: Int, type: AnimatablePosterType) -> some View {
        self.modifier(AnimateablePosterModifier(id: id, type: type))
    }
}

struct AnimateablePosterModifier: ViewModifier {
    
    private let id: Int
    private let type: AnimatablePosterType
    
    @State private var rect: CGRect = .zero
    
    init(id: Int, type: AnimatablePosterType) {
        self.id = id
        self.type = type
    }
    
    func body(content: Content) -> some View {
        content
            .readRect(into: $rect)
            .preference(key: AnimatablePosterPreferenceKey.self, value: [
                .init(id: id, type: type): rect
            ])
    }
}

struct AnimatablePosterPreferenceKey: PreferenceKey {
   
   static var defaultValue: [AnimatablePoster: CGRect] = [:]
   
   static func reduce(value: inout [AnimatablePoster: CGRect], nextValue: () -> [AnimatablePoster: CGRect]) {
       value.merge(nextValue(), uniquingKeysWith: { first, second in first })
   }
}

enum AnimatablePosterType {
    case recommendedShow
    case scheduledShow
    case favoriteShow
}

struct AnimatablePoster: Equatable, Hashable {
    let id: Int
    let type: AnimatablePosterType
}
