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
    private var mainViewModel = MainViewModel.instance
    
    private let showsService: ShowsServiceProtocol = ServiceFactory.showsService
    
    init() {
        setupCancellables()
    }
}

private extension SearchViewModel {
    
    func setupCancellables() {
        self.$searchText
            .sink { [weak self] query in
                if !query.isEmpty {
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
                self.mainViewModel.showToast("Error searching shows: \(error)")
                self.searchedShows = []
                self.isSearchingForShows = false
            }
        }
    }
}
