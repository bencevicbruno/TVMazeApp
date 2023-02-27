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
        TVMazeScrollView(title: "Favorites",
                         isTitleHidden: mainViewModel.isTitleHidden,
                         firstThreshold: viewModel.favoriteShows.isEmpty ? UIScreen.height : 16 + FavoriteShowCard.height,
                         secondThreshold: viewModel.favoriteShows.isEmpty ? UIScreen.height : 2 * 16 + FavoriteShowCard.height) {
            favoritesContent
                .padding(.top, 16)
                .padding(.bottom, MainTabBar.shadowSize + MainTabBar.height)
        } onRefresh: {
            viewModel.refresh()
        }
        .storeAnimatableRects(in: $animatableRects)
        .edgesIgnoringSafeArea(.all)
        .presentShowDetails(
            $viewModel.showPrimaryInfo, source: .favorites, imageOrigin: animationImageOrigin, favoriteButtonOrigin: animationFavoriteButtonOrigin)
    }
    
    enum ContentState: Equatable {
        case loading
        case error(mesage: String)
        case loaded
    }
}

private extension FavoritesView {
    
    @ViewBuilder
    var favoritesContent: some View {
        Group {
            if viewModel.favoriteShows.isEmpty {
                noFavoriteContent
            } else {
                favoritesGrid
            }
        }
        .overlay {
            ProgressView()
                .tint(.white)
                .progressViewStyle(.circular)
                .shadow(radius: 16)
                .opacity(viewModel.isLoadingFavoritesShows ? 1 : 0)
                .frame(maxWidth: .infinity)
                .frame(height: Self.visibleContentHeight)
                .allowsHitTesting(false)
        }
    }
    
    var noFavoriteContent: some View {
        VStack(alignment: .center, spacing: 20) {
            Spacer()
            
            Text("No favorite shows")
                .style(.header1, color: .white, alignment: .center)
            
            Text("Tap on the little heart icon to add a show to favorites.")
                .style(.lightBodyLarge, color: .white, alignment: .center)
            
            Spacer()
        }
        .padding(.horizontal, 64)
        .frame(maxWidth: .infinity)
        .frame(height: Self.visibleContentHeight)
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
        .padding(.horizontal, 16)
    }
    
    func showDetails(_ details: ShowPrimaryInfoModel) {
        self.animationImageOrigin = animatableRects[.init(id: details.id, type: .favoriteShowCard)]
        self.animationFavoriteButtonOrigin = animatableRects[.init(id: details.id, type: .favoriteButton)]
        
        withAnimation(AnimationUtils.toggleBarsAnimation) {
            self.mainViewModel.isTabBarVisible = false
            self.mainViewModel.isTitleHidden = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + AnimationUtils.toggleBarsDuration) {
            self.viewModel.showPrimaryInfo = details
        }
    }
    
    static let visibleContentHeight: CGFloat = UIScreen.height - (UIScreen.unsafeTopPadding + .textSizeDisplay + 2 * 8 + MainTabBar.height)
}

struct FavoritesView_Previews: PreviewProvider {
    
    static var previews: some View {
        FavoritesView()
    }
}
