//
//  FavoritesViewModel.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 14.02.2023..
//

import Combine
import SwiftUI

final class FavoritesViewModel: ObservableObject {
    
    @Published var isLoadingFavoritesShows = true
    @Published var favoriteShows: [FavoriteShowModel] = []
    
    @Published var showPrimaryInfo: ShowPrimaryInfoModel?
    
    private var isRefreshing = false
    private var cancellables: Set<AnyCancellable> = []
    private var mainViewModel = MainViewModel.instance
    
    private let showsService: ShowsServiceProtocol = ServiceFactory.showsService
    private let favoritesService = FavoritesService.instance
    
    init() {
        loadFavorites()
        
        favoritesService.$refreshToken.sink { [weak self] _ in
            self?.loadFavorites()
        }
        .store(in: &cancellables)
    }
    
    // MARK: - User Interaction
    
    func refresh() {
        guard !isRefreshing else { return }
        self.isRefreshing = true
        loadFavorites()
    }
}

private extension FavoritesViewModel {
    
    func loadFavorites() {
        withAnimation {
            isLoadingFavoritesShows = true
        }
        
        Task { @MainActor in
            
            do {
                let favorites = try await self.showsService.fetchFavoriteShows()
                withAnimation {
                    self.favoriteShows = favorites
                }
            } catch {
                self.mainViewModel.showToast("Error loading favorites: \(error)")
                withAnimation {
                    self.favoriteShows = []
                }
            }
            
            self.isLoadingFavoritesShows = false
            self.isRefreshing = false
        }
    }
}
