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
    let image: ImageResponse?
    let summary: String?
    let embedded: CastResponse?
    
    struct Rating: Decodable {
        let average: Double?
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, genres, rating, image, summary
        case embedded = "_embedded"
    }
}

struct CastResponse: Decodable {
    let cast: [CastMember]
    
    struct CastMember: Decodable {
        let person: Person
        let character: Character?
        
        struct Person: Decodable {
            let id: Int
            let name: String
            let image: ImageResponse?
        }

        struct Character: Decodable {
            let id: Int
            let name: String
        }
    }
}



struct ImageResponse: Decodable {
    let medium: String
    let original: String
}

enum TVMazeAPIError: Error {
    case invalidURL(String)
}

final class TVMazeAPI {
    
    static let instance = TVMazeAPI()
    
    func fetchShows(query: String) async throws -> [EmbeddedShow] {
        let url = "https://api.tvmaze.com/search/shows?q=\(query)"
        
        return try await fetchJSON(url: url)
    }
    
    func fetchScheduledShows(for date: Date = .now) async throws -> [ScheduledShowResponse] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        let url = "https://api.tvmaze.com/schedule/web?date=\(dateFormatter.string(from: date))"
        
        return try await fetchJSON(url: url)
    }
    
    func fetchShow(id: Int) async throws -> SingleShowResponse {
        let url = "https://api.tvmaze.com/shows/\(id)?embed=cast"
        
        return try await fetchJSON(url: url)
    }
}

private extension TVMazeAPI {
    
    func fetchJSON<T>(url urlString: String) async throws -> T where T: Decodable {
        guard let url = URL(string: urlString) else {
            throw TVMazeAPIError.invalidURL(urlString)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        return try JSONDecoder().decode(T.self, from: data)
    }
}
