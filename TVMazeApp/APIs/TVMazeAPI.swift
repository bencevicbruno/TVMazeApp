//
//  TVMazeAPI.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 15.02.2023..
//

import Foundation

struct ScheduledShowResponse: Decodable {
    let airdate: String
    let embedded: EmbeddedShow
    
    enum CodingKeys: String, CodingKey {
        case airdate
        case embedded = "_embedded"
    }
}

struct EmbeddedShow: Decodable {
    let show: SingleShowResponse
}

struct SingleShowResponse: Decodable {
    let id: Int
    let name: String
    let genres: [String]
    let rating: Rating
    let image: Image?
    let summary: String?
    
    struct Rating: Decodable {
        let average: Double?
    }
    
    struct Image: Decodable {
        let medium: String
        let original: String
    }
}

enum TVMazeAPIError: Error {
    case invalidURL(String)
}

final class TVMazeAPI {
    
    static let instance = TVMazeAPI()
    
    func fetchShows(query: String) async throws -> [EmbeddedShow] {
        let urlString = "https://api.tvmaze.com/search/shows?q=\(query)"
        
        guard let url = URL(string: urlString) else {
            throw TVMazeAPIError.invalidURL(urlString)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        return try JSONDecoder().decode([EmbeddedShow].self, from: data)
    }
    
    func fetchScheduledShows(for date: Date = .now) async throws -> [ScheduledShowResponse] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        let urlString = "https://api.tvmaze.com/schedule/web?date=\(dateFormatter.string(from: date))"
        
        guard let url = URL(string: urlString) else {
            throw TVMazeAPIError.invalidURL(urlString)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let decodingDateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(decodingDateFormatter)
        return try JSONDecoder().decode([ScheduledShowResponse].self, from: data)
    }
    
    func fetchShow(id: Int) async throws -> SingleShowResponse {
        let urlString = "https://api.tvmaze.com/search/shows/\(id)"
        
        guard let url = URL(string: urlString) else {
            throw TVMazeAPIError.invalidURL(urlString)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        return try JSONDecoder().decode(SingleShowResponse.self, from: data)
    }
}
