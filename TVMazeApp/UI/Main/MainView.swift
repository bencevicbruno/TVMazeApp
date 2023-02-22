//
//  MainView.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 21.02.2023..
//

import SwiftUI

struct MainView: View {
    
    @ObservedObject var viewModel = MainViewModel.instance
    
    @State private var mainTabBarRect: CGRect = .zero
    
    var body: some View {
        TabView(selection: $viewModel.currentTab) {
            HomeView()
                .tag(MainTab.home)
                .simultaneousGesture(viewModel.areBarsHidden ? DragGesture() : nil)
            
            SearchView()
                .tag(MainTab.search)
                .simultaneousGesture(viewModel.areBarsHidden ? DragGesture() : nil)
            
            FavoritesView()
                .tag(MainTab.favorites)
                .simultaneousGesture(viewModel.areBarsHidden ? DragGesture() : nil)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .overlay(alignment: .bottom) {
            MainTabBar($viewModel.currentTab)
                .allowsHitTesting(viewModel.isTabBarVisible)
                .readRect(into: $mainTabBarRect)
                .offset(y: viewModel.isTabBarVisible ? 0 : (mainTabBarRect.height + MainTabBar.shadowSize))
                .animation(.linear, value: viewModel.isTabBarVisible)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct MainView_Previews: PreviewProvider {
    
    static var previews: some View {
        MainView()
    }
}
