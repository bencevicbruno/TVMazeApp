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

final class NetworkService {
    
    static let instance = NetworkService()
    
    private init() {}
    
    func fetchJSON<T>(url urlString: String) async throws -> T where T: Decodable {
        guard let url = URL(string: urlString) else {
            throw NetworkServiceError.invalidURL(urlString)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        print("===== INCOMING RESPONSE =====")
        print("URL: \(urlString)")
        print("Data: \(String(data: data, encoding: .utf8) ?? "None")")
        
//        try await Task.sleep(for: .seconds(5))
        
        return try JSONDecoder().decode(T.self, from: data)
    }
}
