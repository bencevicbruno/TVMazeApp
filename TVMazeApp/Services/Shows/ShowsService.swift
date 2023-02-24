//
//  ShowsService.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 15.02.2023..
//

import Foundation

final class ShowsService {
    
    static let instance = ShowsService()
    
    private let favoritesService = FavoritesService.instance
    private let tvMazeAPI = TVMazeAPI.instance
    
    private init() {}
    
    func fetchRecommendedShows() async throws -> [RecommendedShowModel] {
        let queries = ["Blue", "The", "of", "Another", "Time"]
        
        return try await tvMazeAPI.fetchShows(query: queries.randomElement()!)
            .compactMap { .init(from: $0.show) }
            .uniqueOnly
            .prefix(10)
            .toArray
            .sorted {
                $0.rating > $1.rating
            }
    }
    
    func fetchScheduledShows() async throws -> [ScheduledShowModel] {
        return try await tvMazeAPI.fetchScheduledShows()
            .compactMap { .init(from: $0) }
            .uniqueOnly
            .prefix(20)
            .toArray
    }
    
    func searchShows(keyword: String) async throws -> [SearchShowModel] {
        return try await tvMazeAPI.fetchShows(query: keyword)
            .compactMap { .init(from: $0.show) }
            .uniqueOnly
            .prefix(10)
            .toArray
            .sorted {
                $0.rating > $1.rating
            }
    }
    
    func fetchShowCast(id: Int) async throws -> ShowCastModel {
        if let result = ShowCastModel(from: try await tvMazeAPI.fetchShow(id: id)) {
            return result
        } else {
            throw TVMazeAPIError.noCastData
        }
    }
    
    func fetchFavoriteShows() async throws -> [FavoriteShowModel] {
        let favorites = favoritesService.favorites

        guard !favorites.isEmpty else { return [] }

        var result = [FavoriteShowModel?]()

        for id in favorites {
            result.append(try await .init(from: tvMazeAPI.fetchShow(id: id)))
        }

        return result.compactMap { $0 }
    }
}
