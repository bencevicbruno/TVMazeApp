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
    let description: String
    
    init(from model: RecommendedShowModel) {
        self.id = model.id
        self.title = model.title
        self.poster = CacheService.instance.getImage(for: model.posterURL) ?? UIImage(named: "placeholder_panda")!
        self.description = model.description
    }
    
    init(from model: ScheduledShowModel) {
        self.id = model.id
        self.title = model.title
        self.poster = CacheService.instance.getImage(for: model.posterURL) ?? UIImage(named: "placeholder_panda")!
        self.description = model.description
    }
    
    init(from model: FavoriteShowModel) {
        self.id = model.id
        self.title = model.title
        self.poster = CacheService.instance.getImage(for: model.posterURL) ?? UIImage(named: "placeholder_panda")!
        self.description = model.description
    }
}

final class HomeViewModel: ObservableObject {
    
    @Published var isLoadingRecommendedShows = true
    @Published var isLoadingScheduledShows = true
    
    @Published private(set) var recommendedShows: [RecommendedShowModel] = []
    @Published private(set) var scheduledShows: [ScheduledShowModel] = []
    
    @Published var showPrimaryInfo: ShowPrimaryInfoModel?
    
    private let showsService = ShowsService.instance
    
    init() {
        fetchShows()
    }
    
    func refresh() {
        fetchShows()
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
