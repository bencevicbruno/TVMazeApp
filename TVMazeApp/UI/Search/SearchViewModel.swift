//
//  SearchViewModel.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 24.02.2023..
//

import Combine
import SwiftUI

final class SearchViewModel: ObservableObject {
    
    @Published var searchText = ""
    
    @Published var searchedShows: [SearchShowModel] = []
    @Published var isSearchingForShows = false
    
    @Published var showPrimaryInfo: ShowPrimaryInfoModel?
    
    private var cancellables: Set<AnyCancellable> = []
    
    private let showsService = ShowsService.instance
    
    init() {
        setupCancellables()
    }
}

private extension SearchViewModel {
    
    func setupCancellables() {
        self.$searchText
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .sink { [weak self] query in
                if query.isEmpty {
                    self?.searchedShows = []
                } else {
                    self?.searchShows(query: query)
                }
            }
            .store(in: &cancellables)
    }
    
    func searchShows(query: String) {
        self.isSearchingForShows = true
        
        Task { @MainActor in
            do {
                self.searchedShows = try await showsService.searchShows(keyword: query)
                self.isSearchingForShows = false
            } catch {
                print("Error searching shows: \(error)")
                self.searchedShows = []
                self.isSearchingForShows = false
            }
        }
    }
}
