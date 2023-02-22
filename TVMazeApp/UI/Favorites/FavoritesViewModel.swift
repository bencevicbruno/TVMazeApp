//
//  FavoritesViewModel.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 14.02.2023..
//

import Combine
import SwiftUI

final class FavoritesViewModel: ObservableObject {
    
    @Published var contentState: FavoritesView.ContentState = .loading
    @Published var favoriteShows: [FavoriteShowModel] = []
    
    @Published var showPrimaryInfo: ShowPrimaryInfoModel?
    
    private var isRefreshing = false
    private var cancellables: Set<AnyCancellable> = []
    
    private let showsService = ShowsService.instance
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
            contentState = .loading
        }
        
        Task { @MainActor in
            
            do {
                self.favoriteShows = try await self.showsService.fetchFavoriteShows()
                withAnimation {
                    contentState = .loaded
                }
            } catch {
                withAnimation {
                    contentState = .error(mesage: error.localizedDescription)
                }
            }
            
            isRefreshing = false
        }
    }
}
