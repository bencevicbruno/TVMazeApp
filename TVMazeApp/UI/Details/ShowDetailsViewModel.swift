//
//  ShowDetailsViewModel.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 17.02.2023..
//

import SwiftUI

final class ShowDetailsViewModel: ObservableObject {
    
    @Published var isLoadingEpisodes = true
    @Published var isLoadingCast = true
    @Published var isLoadingSimilarShows = true
    
    @Published var episodes: [Int: [ShowEpisodeModel]]?
    @Published var cast: ShowCastModel?
    @Published var similarShows: [SimialarShowModel] = []
    
    @Published var similarShowPrimaryInfo: ShowPrimaryInfoModel?
    
    let model: ShowPrimaryInfoModel
    
    private var mainViewModel = MainViewModel.instance
    
    private let showsService: ShowsServiceProtocol = ServiceFactory.showsService
    
    init(model: ShowPrimaryInfoModel) {
        self.model = model
        fetchEpisodes()
        fetchCast()
        fetchSimilarShows()
    }
}

private extension ShowDetailsViewModel {
    
    private func fetchEpisodes() {
        self.isLoadingEpisodes = true
        
        Task { @MainActor in
            do {
                let result = try await showsService.fetchShowsEpisodes(id: model.id)
                
                withAnimation {
                    self.episodes = result
                }
            } catch {
                mainViewModel.showToast("Error loading episodes: \(error)")
            }
            
            self.isLoadingEpisodes = false
        }
    }
    
    private func fetchCast() {
        self.isLoadingCast = true
        
        Task { @MainActor in
            do {
                let result = try await showsService.fetchShowCast(id: model.id)
                
                withAnimation {
                    self.cast = result
                }
            } catch {
                mainViewModel.showToast("Error loading cast: \(error)")
            }
            
            self.isLoadingCast = false
        }
    }
    
    private func fetchSimilarShows() {
        self.isLoadingSimilarShows = true
        
        Task { @MainActor in
            do {
                let result = try await showsService.fetchSimilarShows(title: model.title).filter { $0.id != model.id }
                
                withAnimation {
                    self.similarShows = result
                }
            } catch {
                mainViewModel.showToast("Error loading recommended shows: \(error)")
            }
            
            self.isLoadingSimilarShows = false
        }
    }
}
