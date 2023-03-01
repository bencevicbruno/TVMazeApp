//
//  ServiceFactory.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 01.03.2023..
//

import Foundation

enum ServiceFactory {
    
    static let networkService: NetworkServiceProtocol = SlowNetworkService()
    
    static let showsService: ShowsServiceProtocol = ShowsService()
}
