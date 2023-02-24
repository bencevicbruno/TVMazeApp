//
//  HomeView.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 12.02.2023..
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var viewModel = HomeViewModel()
    
    @ObservedObject var favoritesService = FavoritesService.instance
    @ObservedObject var mainViewModel = MainViewModel.instance
    
    @State private var recommendedShowsOffset: CGPoint = .zero
    @State private var scrollViewOffset: CGPoint = .zero
    
    @State private var animatableRects: [AnimatableRect: CGRect] = [:]
    @State private var animationSource: ShowDetailsSource = .recommended
    @State private var animationImageOrigin: CGRect?
    @State private var animationFavoriteButtonOrigin: CGRect?
    
    var body: some View {
        TVMazeScrollView(title: "Shows", isTitleHidden: mainViewModel.isTitleHidden, firstThreshold: RecommendedShowCard.height + 24, secondThreshold: RecommendedShowCard.height + 2 * 24) {
            VStack(alignment: .leading, spacing: 0) {
                recommendedShows
                    .padding(.vertical, 24)
                
                scheduledShows
            }
            .padding(.bottom, MainTabBar.shadowSize)
            .frame(maxWidth: .infinity)
            .allowsHitTesting(viewModel.showPrimaryInfo == nil)
        } onRefresh: {
            viewModel.refresh()
        }
        .storeAnimatableRects(in: $animatableRects)
        .edgesIgnoringSafeArea(.all)
        .presentShowDetails(
            $viewModel.showPrimaryInfo, source: animationSource, imageOrigin: animationImageOrigin, favoriteButtonOrigin: animationFavoriteButtonOrigin)
    }
}

private extension HomeView {
    
    // MARK: Recommended Shows
    
    @ViewBuilder
    var recommendedShows: some View {
        if viewModel.isLoadingRecommendedShows {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.tvMazeDarkGray)
                .frame(width: RecommendedShowCard.width, height: RecommendedShowCard.height)
                .overlay {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(.white)
                }
                .padding(.horizontal, 64)
        } else {
            SnappableScrollView(axes: .horizontal, showsIndicator: false, offset: $recommendedShowsOffset) {
                HStack(spacing: 16) {
                    ForEach(viewModel.recommendedShows) { model in
                        RecommendedShowCard(model: model, isFavorite: favoritesService.binding(for: model.id))
                            .id(model.id)
                            .onTapGesture {
                                showDetails(.init(from: model), source: .recommended, type: .recommendedShowCard)
                            }
                    }
                }
                .padding(.horizontal, 64)
            } onSnap: { proxy in
                let offsetWithoutPadding = -recommendedShowsOffset.x - 64
                let potentialIndex = offsetWithoutPadding / (RecommendedShowCard.width + 16)
                let showIndex = Int(round(potentialIndex))
                
                let showID = viewModel.recommendedShows[showIndex].id
                proxy.scrollTo(showID, anchor: .center)
            }
        }
    }
    
    // MARK: Scheduled Shows
    
    var scheduledShows: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Scheduled")
                .style(.header2, color: .white)
                .padding(.leading, 16)
            
            if viewModel.isLoadingScheduledShows {
                ProgressView()
                    .progressViewStyle(.circular)
                    .frame(maxWidth: .infinity)
                    .frame(height: UIScreen.width / 2)
            } else if viewModel.scheduledShows.isEmpty {
                Text(verbatim: "No scheduled shows found.")
                    .style(.boldBodyDefault, color: .white, alignment: .center)
                    .frame(maxWidth: .infinity)
                    .frame(height: UIScreen.width / 2)
            } else {
                VStack(spacing: 16) {
                    ForEach(viewModel.scheduledShows) { show in
                        ScheduledShowCard(model: show)
                            .onTapGesture {
                                showDetails(.init(from: show), source: .scheduled, type: .scheduledShowCard)
                            }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, MainTabBar.height)
            }
        }
    }
    
    func showDetails(_ details: ShowPrimaryInfoModel, source: ShowDetailsSource, type: AnimatableRectType) {
        withAnimation(AnimationUtils.toggleBarsAnimation) {
            self.mainViewModel.isTabBarVisible = false
            self.mainViewModel.isTitleHidden = true
        }
        
        self.animationSource = source
        self.animationImageOrigin = animatableRects[.init(id: details.id, type: type)]
        self.animationFavoriteButtonOrigin = animatableRects[.init(id: details.id, type: .favoriteButton)]
        
        DispatchQueue.main.asyncAfter(deadline: .now() + AnimationUtils.toggleBarsDuration) {
            self.viewModel.showPrimaryInfo = details
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    
    static var previews: some View {
        HomeView()
    }
}
