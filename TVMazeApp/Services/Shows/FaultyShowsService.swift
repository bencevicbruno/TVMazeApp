//
//  FaultyShowsService.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 28.02.2023..
//

import Foundation

final class FaultyShowsService: ShowsServiceProtocol {
    
    func fetchRecommendedShows() async throws -> [RecommendedShowModel] {
        try await Task.sleep(for: .seconds(2))
        throw TVMazeAPIError.faultyService
    }
    
    func fetchScheduledShows() async throws -> [ScheduledShowModel] {
        try await Task.sleep(for: .seconds(2))
        throw TVMazeAPIError.faultyService
    }
    
    func searchShows(keyword: String) async throws -> [SearchShowModel] {
        try await Task.sleep(for: .seconds(2))
        throw TVMazeAPIError.faultyService
    }
    
    func fetchShowCast(id: Int) async throws -> ShowCastModel {
        try await Task.sleep(for: .seconds(2))
        throw TVMazeAPIError.faultyService
    }
    
    func fetchShowsEpisodes(id: Int) async throws -> [Int : [ShowEpisodeModel]] {
        try await Task.sleep(for: .seconds(2))
        throw TVMazeAPIError.faultyService
    }
    
    func fetchSimilarShows(title: String) async throws -> [SimialarShowModel] {
        try await Task.sleep(for: .seconds(2))
        throw TVMazeAPIError.faultyService
    }
    
    func fetchFavoriteShows() async throws -> [FavoriteShowModel] {
        try await Task.sleep(for: .seconds(2))
        throw TVMazeAPIError.faultyService
    }
}
