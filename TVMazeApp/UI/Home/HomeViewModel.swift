//
//  HomeViewModel.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 13.02.2023..
//

import SwiftUI

final class HomeViewModel: ObservableObject {
    
    @Published var isLoadingRecommendedShows = true
    @Published var isLoadingScheduledShows = true
    
    @Published private(set) var recommendedShows: [RecommendedShowModel] = []
    @Published private(set) var scheduledShows: [ScheduledShowModel] = []
    
    @Published var showPrimaryInfo: ShowPrimaryInfoModel?
    
    private var mainViewModel = MainViewModel.instance
    
    private let showsService: ShowsServiceProtocol = ServiceFactory.showsService
    
    init() {
        fetchShows()
    }
    
    func refresh() {
        fetchShows()
    }
    
    func fetchShows() {
        self.recommendedShows = []
        self.scheduledShows = []
        
        Task { @MainActor in
            self.isLoadingRecommendedShows = true
            
            do {
                self.recommendedShows = try await showsService.fetchRecommendedShows()
                self.isLoadingRecommendedShows = false
            } catch {
                self.mainViewModel.showToast("Error fetching recommended shows: \(error)")
                self.isLoadingRecommendedShows = false
            }
        }
        
        Task { @MainActor in
            self.isLoadingScheduledShows = true

            do {
                self.scheduledShows = try await showsService.fetchScheduledShows()
                self.isLoadingScheduledShows = false
            } catch {
                self.mainViewModel.showToast("Error fetching scheduled shows: \(error)")
                self.isLoadingScheduledShows = false
            }
        }
    }
}
