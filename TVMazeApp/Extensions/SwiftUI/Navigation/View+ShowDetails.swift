//
//  View+ShowDetails.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 24.02.2023..
//

import SwiftUI

enum ShowDetailsSource {
    case recommended
    case scheduled
    case search
    case favorites
}

extension View {
    
    func presentShowDetails(_ binding: Binding<ShowPrimaryInfoModel?>, source: ShowDetailsSource, imageOrigin: CGRect? = nil, favoriteButtonOrigin: CGRect? = nil) -> some View {
        ZStack {
            self
            
            if let model = binding.wrappedValue {
                ShowDetailsView(
                    model: model,
                    isVisible: .init(
                        get: {
                            binding.wrappedValue != nil
                        }, set: { visible in
                            if !visible {
                                binding.wrappedValue = nil
                            }
                        }),
                    source: source,
                    imageOrigin: imageOrigin ?? .zero,
                    favoriteButtonOrigin: favoriteButtonOrigin)
            }
        }
    }
}
