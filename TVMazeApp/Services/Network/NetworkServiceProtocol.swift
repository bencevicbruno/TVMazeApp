//
//  NetworkServiceProtocol.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 01.03.2023..
//

import Foundation

protocol NetworkServiceProtocol: AnyObject {
    
    func fetchData(url urlString: String) async throws -> Data
    func fetchJSON<T>(url urlString: String) async throws -> T where T: Decodable
}
