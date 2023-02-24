//
//  TVMazeAPI.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 15.02.2023..
//

import Foundation

final class TVMazeAPI {
    
    static let instance = TVMazeAPI()
    
    private let networkService = NetworkService.instance
    
    private init() {}
    
    func fetchShows(query: String) async throws -> [ScheduledShowResponse.EmbeddedShow] {
        let url = "https://api.tvmaze.com/search/shows?q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query)"
        
        return try await networkService.fetchJSON(url: url)
    }
    
    func fetchScheduledShows(for date: Date = .now) async throws -> [ScheduledShowResponse] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        let url = "https://api.tvmaze.com/schedule/web?date=\(dateFormatter.string(from: date))"
        
        return try await networkService.fetchJSON(url: url)
    }
    
    func fetchShow(id: Int) async throws -> SingleShowResponse {
        let url = "https://api.tvmaze.com/shows/\(id)?embed=cast"
        
        return try await networkService.fetchJSON(url: url)
    }
}
