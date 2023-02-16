//
//  FavoritesViewModel.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 14.02.2023..
//

import SwiftUI

final class FavoritesViewModel: ObservableObject {
    
    @Published var canShowEmptyState = false
    @Published var isLoadingFavorites = false
    @Published var favoriteShows: [FavoriteShowModel] = []
    
    init() {
        loadFavorites()
    }
    
    // MARK: - User Interaction
    
    func refresh() {
        loadFavorites()
    }
}

private extension FavoritesViewModel {
    
    func loadFavorites() {
        canShowEmptyState = false
        
        withAnimation {
            isLoadingFavorites = true
            self.favoriteShows = []
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            guard let self else { return }
            
            let newShows = (1...10).randomElement()! > 5 ? Array(1...10) : []
            self.canShowEmptyState = newShows.isEmpty
            
            withAnimation {
                self.favoriteShows = (1...10).map { .sample(withID: $0) }
            }
            self.isLoadingFavorites = false
        }
    }
}
