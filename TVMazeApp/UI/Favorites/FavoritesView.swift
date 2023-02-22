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
        TVMazeScrollView(title: "Favorites", isTitleHidden: mainViewModel.isTitleHidden) {
            favoritesContent
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
    
    var favoritesContent: some View {
        Group {
            switch viewModel.contentState {
            case .loading:
                Color.clear
                    .allowsHitTesting(false)
            case let .error(message):
                Text("Error\n\(message)")
            case .loaded:
                if viewModel.favoriteShows.isEmpty {
                    noFavoriteContent
                } else {
                    favoritesGrid
                }
            }
        }
        .frame(width: UIScreen.width)
        .overlay {
            ProgressView()
                .tint(.white)
                .progressViewStyle(.circular)
                .opacity(viewModel.contentState == .loading ? 1 : 0)
                .allowsHitTesting(false)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
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
