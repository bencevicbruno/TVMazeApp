//
//  FavoritesView.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 13.02.2023..
//

import SwiftUI

struct FavoritesView: View {
    
    @StateObject var viewModel = FavoritesViewModel()
    
    @ObservedObject var mainViewModel = MainViewModel.instance
    @ObservedObject var favoritesService = FavoritesService.instance
    
    @State private var animatableRects: [AnimatableRect: CGRect] = [:]
    @State private var animationImageOrigin: CGRect?
    @State private var animationFavoriteButtonOrigin: CGRect?
    
    var body: some View {
        TVMazeScrollView(title: "Shows", isTitleHidden: mainViewModel.isTitleHidden) {
            Group {
                if viewModel.canShowEmptyState && viewModel.favoriteShows.isEmpty {
                    noFavoriteContent
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if viewModel.favoriteShows.isEmpty {
                    Color.clear
                } else {
                    favoritesGrid
                }
            }
        } onRefresh: {
            viewModel.refresh()
        }
        .storeAnimatableRects(in: $animatableRects)
        .edgesIgnoringSafeArea(.all)
        .presentShowDetails(
            $viewModel.showPrimaryInfo, source: .favorites, imageOrigin: animationImageOrigin, favoriteButtonOrigin: animationFavoriteButtonOrigin)
    }
}

private extension FavoritesView {
    
    var noFavoriteContent: some View {
        VStack(alignment: .center, spacing: 20) {
            Spacer()
            
            Spacer()
            
            Spacer()
            
            Text("No favorite shows")
                .style(.header1, color: .white, alignment: .center)
            
            Text("Tap on the little heart icon to add a show to favorites.")
                .style(.lightBodyLarge, color: .white, alignment: .center)
            
            Spacer()
            
            Text("Tap to refresh")
                .style(.boldBodyDefault, color: .tvMazeDarkGray)
                .padding(.horizontal, 32)
                .padding(.vertical, 16)
                .background(Color.tvMazeWhite)
                .clipShape(Capsule())
                .contentShape(Capsule())
                .onTapGesture {
                    viewModel.refresh()
                }
            
            Spacer()
        }
        .padding(.horizontal, 64)
    }
    
    var favoritesGrid: some View {
        LazyVGrid(columns: [.init(.flexible(), spacing: 16), .init(.flexible())], alignment: .center, spacing: 16) {
            ForEach(viewModel.favoriteShows, id: \.self) { show in
                FavoriteShowCard(model: show, isFavorite: favoritesService.binding(for: show.id))
                    .onTapGesture {
                        showDetails(.init(from: show))
                    }
                    .id(show.id)
            }
        }
        .frame(width: UIScreen.width - 2 * 16)
        .padding(.horizontal, 16)
    }
    
    func showDetails(_ details: ShowPrimaryInfoModel) {
        withAnimation(AnimationUtils.toggleBarsAnimation) {
            self.mainViewModel.isTabBarVisible = false
            self.mainViewModel.isTitleHidden = true
        }
        
        self.animationImageOrigin = animatableRects[.init(id: details.id, type: .favoriteShowCard)]
        self.animationFavoriteButtonOrigin = animatableRects[.init(id: details.id, type: .favoriteButton)]
        print(animatableRects)
        DispatchQueue.main.asyncAfter(deadline: .now() + AnimationUtils.toggleBarsDuration) {
            self.viewModel.showPrimaryInfo = details
        }
    }
}

struct FavoritesView_Previews: PreviewProvider {
    
    static var previews: some View {
        FavoritesView()
    }
}
