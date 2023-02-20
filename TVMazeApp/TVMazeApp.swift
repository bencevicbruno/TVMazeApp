//
//  TVMazeApp.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 12.02.2023..
//

import SwiftUI

final class MainViewModel: ObservableObject {
    
    @Published var currentTab: MainTab = .home
    @Published var isTabBarVisible = true
    
    private init() {}
    
    static let instance = MainViewModel()
}

@main
struct TVMazeApp: App {
    
    init() {
        UIFont.printFonts()
    }
    
    @ObservedObject var viewModel = MainViewModel.instance
    
    @State private var mainTabBarRect: CGRect = .zero
    
    var body: some Scene {
        WindowGroup {
            TabView(selection: $viewModel.currentTab) {
                HomeView()
                    .tag(MainTab.home)
                
                SearchView()
                    .tag(MainTab.search)
                
                FavoritesView()
                    .tag(MainTab.favorites)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .overlay(alignment: .bottom) {
                MainTabBar($viewModel.currentTab)
                    .allowsHitTesting(viewModel.isTabBarVisible)
                    .readRect(into: $mainTabBarRect)
                    .offset(y: viewModel.isTabBarVisible ? 0 : mainTabBarRect.height + MainTabBar.shadowSize)
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}
