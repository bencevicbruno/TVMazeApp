//
//  ShowsServiceProtocol.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 28.02.2023..
//

import Foundation

protocol ShowsServiceProtocol: AnyObject {
    
    func fetchRecommendedShows() async throws -> [RecommendedShowModel]
    func fetchScheduledShows() async throws -> [ScheduledShowModel]
    func searchShows(keyword: String) async throws -> [SearchShowModel]
    func fetchShowCast(id: Int) async throws -> ShowCastModel
    func fetchShowsEpisodes(id: Int) async throws -> [Int: [ShowEpisodeModel]]
    func fetchSimilarShows(title: String) async throws -> [SimialarShowModel]
    func fetchFavoriteShows() async throws -> [FavoriteShowModel]
}
