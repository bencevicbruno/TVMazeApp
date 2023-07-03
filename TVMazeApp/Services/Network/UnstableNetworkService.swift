//
//  UnstableNetworkService.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 31.03.2023..
//

import Foundation

final class UnstableNetworkService: NetworkServiceProtocol {
    
    func fetchData(url urlString: String) async throws -> Data {
        guard let url = URL(string: urlString) else {
            throw NetworkServiceError.invalidURL(urlString)
        }
        
        if (1...10).randomElement()! <= 7 {
            try await Task.sleep(for: .seconds((2...7).randomElement()!))
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        if (1...10).randomElement()! <= 7 {
            throw TVMazeAPIError.faultyService
        }
        
        return data
    }
    
    func fetchJSON<T>(url urlString: String) async throws -> T where T : Decodable {
        let data = try await fetchData(url: urlString)
        
//        print("===== INCOMING RESPONSE =====")
//        print("URL: \(urlString)")
//        print("Data: \(String(data: data, encoding: .utf8) ?? "None")")
        
        return try JSONDecoder().decode(T.self, from: data)
    }
}


