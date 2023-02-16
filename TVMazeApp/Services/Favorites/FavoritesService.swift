//
//  FavoritesService.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 15.02.2023..
//

import SwiftUI

final class FavoritesService: ObservableObject {
    
    private(set) var favorites: [Int] = []
    
    static let instance = FavoritesService()
    
    @Published var refreshToken = true
    
    init() {
        
    }
    
    func isFavorite(_ id: Int) -> Bool {
        return favorites.contains(where: { $0 == id })
    }
    
    func addToFavorites(_ id: Int) {
        favorites.append(id)
        refreshToken.toggle()
    }
    
    func removeFromFavorites(_ id: Int) {
        favorites.removeAll(where: { $0 == id })
        refreshToken.toggle()
    }
    
    func binding(for id: Int) -> Binding<Bool> {
        return .init(get: { [weak self] in
            return self?.isFavorite(id) ?? false
        }, set: { [weak self] newValue in
            if newValue {
                self?.addToFavorites(id)
            } else {
                self?.removeFromFavorites(id)
            }
        })
    }
}
