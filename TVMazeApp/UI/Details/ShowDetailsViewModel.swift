//
//  ShowDetailsViewModel.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 17.02.2023..
//

import SwiftUI

final class ShowDetailsViewModel: ObservableObject {
    
    @Published var castContentState: ShowDetailsCastSection.ContentState = .loading
    
    let model: ShowPrimaryInfoModel
    
    private let showsService = ShowsService.instance
    
    init(model: ShowPrimaryInfoModel) {
        self.model = model
        fetchCast()
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
                print("Error loading cast: \(error)")
                castContentState = .error
            }
        }
    }
}
