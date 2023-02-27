//
//  View+AnimatablePoster.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 20.02.2023..
//

import SwiftUI

extension View {
    
    func animatablePoster(id: Int, type: AnimatableRectType) -> some View {
        self.modifier(AnimatableRectModifier(id: id, type: type))
    }
    
    func storeAnimatableRects(in binding: Binding<[AnimatableRect: CGRect]>) -> some View {
        self.onPreferenceChange(AnimatableRectPreferenceKey.self) { value in
            DispatchQueue.main.async {
                binding.wrappedValue = value
            }
        }
    }
}

struct AnimatableRectModifier: ViewModifier {
    
    private let id: Int
    private let type: AnimatableRectType
    
    @State private var rect: CGRect = .zero
    
    init(id: Int, type: AnimatableRectType) {
        self.id = id
        self.type = type
    }
    
    func body(content: Content) -> some View {
        content
            .readRect(into: $rect)
            .preference(key: AnimatableRectPreferenceKey.self, value: [
                .init(id: id, type: type): rect
            ])
    }
}

struct AnimatableRectPreferenceKey: PreferenceKey {
   
   static var defaultValue: [AnimatableRect: CGRect] = [:]
   
   static func reduce(value: inout [AnimatableRect: CGRect], nextValue: () -> [AnimatableRect: CGRect]) {
       value.merge(nextValue(), uniquingKeysWith: { first, second in first })
   }
}

enum AnimatableRectType {
    case recommendedShowCard
    case scheduledShowCard
    case searchResultCard
    case favoriteShowCard
    case favoriteButton
}

struct AnimatableRect: Equatable, Hashable {
    let id: Int
    let type: AnimatableRectType
}
