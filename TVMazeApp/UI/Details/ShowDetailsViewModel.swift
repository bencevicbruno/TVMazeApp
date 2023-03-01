//
//  ShowDetailsViewModel.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 17.02.2023..
//

import SwiftUI

final class ShowDetailsViewModel: ObservableObject {
    
    @Published var episodesContentState: ShowDetailsEpisodesSection.ContentState = .loading
    @Published var castContentState: ShowDetailsCastSection.ContentState = .loading
    
    let model: ShowPrimaryInfoModel
    
    private var mainViewModel = MainViewModel.instance
    
    private let showsService: ShowsServiceProtocol = ServiceFactory.showsService
    
    init(model: ShowPrimaryInfoModel) {
        self.model = model
        fetchCast()
        fetchEpisodes()
    }
}

private extension ShowDetailsViewModel {
    
    private func fetchCast() {
        castContentState = .loading
        
        Task { @MainActor in
            do {
                let cast = try await showsService.fetchShowCast(id: model.id)
                castContentState = .loaded(cast.cast)
            } catch {
                castContentState = .loaded([])
                mainViewModel.showToast("Error loading cast: \(error)")
            }
        }
    }
    
    private func fetchEpisodes() {
        episodesContentState = .loading
        
        Task { @MainActor in
            do {
                episodesContentState = .loaded(try await showsService.fetchShowsEpisodes(id: model.id))
            } catch {
                print(error)
                episodesContentState = .loaded([:])
                mainViewModel.showToast("Error loading episodes: \(error)")
            }
        }
    }
}
