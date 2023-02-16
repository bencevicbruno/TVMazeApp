//
//  TVMazeApp.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 12.02.2023..
//

import SwiftUI

enum MainTab: Identifiable {
    case home
    case search
    case favorites
    
    var id: Self {
        self
    }
    
    
}

@main
struct TVMazeApp: App {
    
    init() {
        UIFont.printFonts()
    }
    
    @State private var currentTab = MainTab.home
    
    var body: some Scene {
        WindowGroup {
            HomeView()
//            AnimatedShowDetailsView(model: .init(from: RecommendedShowModel.sample()),
//                                    isVisible: .constant(true),
//                                    originFrame: .init(x: 50, y: 50, width: RecommendedShowCard.width, height: RecommendedShowCard.imageHeight))
//                .background(.white)
//            TabView(selection: $currentTab) {
//                HomeView()
//                    .tag(MainTab.home)
//                    .tabItem {
//                        Text("Home")
//                    }
//
//                SearchView()
//                    .tag(MainTab.search)
//                    .tabItem {
//                        Text("Search")
//                    }
//
//                FavoritesView()
//                    .tag(MainTab.favorites)
//                    .tabItem {
//                        Text("Favorites")
//                    }
//            }
        }
    }
}
