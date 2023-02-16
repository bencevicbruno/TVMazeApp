//
//  HomeViewModel.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 13.02.2023..
//

import SwiftUI

struct ShowPrimaryInfoModel: Identifiable, Hashable {
    let id: Int
    let title: String
    let poster: UIImage
    
    init(from model: RecommendedShowModel) {
        self.id = model.id
        self.title = model.title
        self.poster = CacheService.instance.getImage(for: model.posterURL)!
    }
    
    init(from model: ScheduledShowModel) {
        self.id = model.id
        self.title = model.title
        self.poster = CacheService.instance.getImage(for: model.posterURL)!
    }
}

final class HomeViewModel: ObservableObject {
    
    @Published var isLoadingRecommendedShows = true
    @Published var isLoadingScheduledShows = true
    
    var shouldRefreshOnScrollEnd = false
    
    @Published private(set) var recommendedShows: [RecommendedShowModel] = []
    @Published private(set) var scheduledShows: [ScheduledShowModel] = []
    
    @Published var showPrimaryInfo: ShowPrimaryInfoModel?
    
    private let showsService = ShowsService.instance
    
    init() {
        fetchShows()
    }
    
    func refresh() {
        guard shouldRefreshOnScrollEnd else { return }
        shouldRefreshOnScrollEnd = false
        fetchShows()
    }
    
    func recommendedShowTapped(_ show: RecommendedShowModel) {
        withAnimation(.easeOut(duration: HomeView.transitionDuration)) {
            showPrimaryInfo = .init(from: show)
        }
    }
    
    func fetchShows() {
        Task { @MainActor in
            self.isLoadingRecommendedShows = true
            
            do {
                print("Fetching")
                self.recommendedShows = try await showsService.fetchRecommendedShows()
                print("done")
                self.isLoadingRecommendedShows = false
            } catch {
                
                print("error")
                print(error)
                self.isLoadingRecommendedShows = false
            }
            
            self.isLoadingScheduledShows = true

            do {
                self.scheduledShows = try await showsService.fetchScheduledShows()
            } catch {
                print(error)
            }

            self.isLoadingScheduledShows = false
        }
    }
}
