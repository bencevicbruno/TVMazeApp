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
    
    @Published var showPrimaryInfo: ShowPrimaryInfoModel?
    
    private let showsService = ShowsService.instance
    
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
        
        Task { @MainActor in
            let newShows = try await self.showsService.fetchFavoriteShows()
            self.canShowEmptyState = newShows.isEmpty
            
            withAnimation {
                self.favoriteShows = newShows
            }
            self.isLoadingFavorites = false
        }
    }
}
