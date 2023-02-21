//
//  MainViewModel.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 21.02.2023..
//

import SwiftUI

final class MainViewModel: ObservableObject {
    
    @Published var currentTab: MainTab = .home
    @Published var isTabBarVisible = true
    @Published var isTitleHidden = false
    
    private init() {}
    
    static let instance = MainViewModel()
}
