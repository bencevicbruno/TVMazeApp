//
//  MainTab.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 17.02.2023..
//

import Foundation

enum MainTab: CaseIterable {
    case home
    case search
    case favorites
    
    func iconName(selected: Bool = false) -> String {
        switch self {
        case .home:
            return selected ? "icon_home_filled" : "icon_home"
        case .search:
            return "icon_search"
        case .favorites:
            return selected ? "icon_heart_filled" : "icon_heart"
        }
    }
}

extension MainTab: Identifiable {
    
    var id: Self {
        self
    }
}
