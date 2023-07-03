//
//  NetworkService.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 24.02.2023..
//

import Foundation

enum NetworkServiceError: Error {
    case invalidURL(String)
}

final class NetworkService: NetworkServiceProtocol {
    
    private let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-YYYY"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        return decoder
    }()
    
    func fetchData(url urlString: String) async throws -> Data {
        guard let url = URL(string: urlString) else {
            throw NetworkServiceError.invalidURL(urlString)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let (data, _) = try await URLSession.shared.data(for: request)
        return data
    }
    
    func fetchJSON<T>(url urlString: String) async throws -> T where T: Decodable {
        let data = try await fetchData(url: urlString)
        
//        print("===== INCOMING RESPONSE =====")
//        print("URL: \(urlString)")
//        print("Data: \(String(data: data, encoding: .utf8) ?? "None")")
        
        return try jsonDecoder.decode(T.self, from: data)
    }
}
