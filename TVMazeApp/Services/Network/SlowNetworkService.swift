//
//  SlowNetworkService.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 01.03.2023..
//

import Foundation

final class SlowNetworkService: NetworkServiceProtocol {
    
    private let networkService = NetworkService()
    
    func fetchData(url urlString: String) async throws -> Data {
        try await Task.sleep(for: .seconds(5))
        
        return try await networkService.fetchData(url: urlString)
    }
    
    func fetchJSON<T>(url urlString: String) async throws -> T where T : Decodable {
        try await Task.sleep(for: .seconds(5))
        
        return try await networkService.fetchJSON(url: urlString)
    }
}
