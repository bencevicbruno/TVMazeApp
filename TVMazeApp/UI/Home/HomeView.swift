//
//  HomeView.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 12.02.2023..
//

import SwiftUI

extension View {
    
    func presentShowDetails(_ binding: Binding<ShowPrimaryInfoModel?>, source: ShowDetailsSource, imageOrigin: CGRect? = nil, favoriteButtonOrigin: CGRect? = nil) -> some View {
        ZStack {
            self
            
            if let model = binding.wrappedValue {
                AnimatedShowDetailsView(
                    model: model,
                    isVisible: .init(
                        get: {
                            binding.wrappedValue != nil
                        }, set: { visible in
                            if !visible {
                                binding.wrappedValue = nil
                            }
                        }),
                    source: source,
                    imageOrigin: imageOrigin ?? .zero,
                    favoriteButtonOrigin: favoriteButtonOrigin)
            }
        }
    }
}

struct HomeView: View {
    
    @StateObject var viewModel = HomeViewModel()
    
    @ObservedObject var favoritesService = FavoritesService.instance
    @ObservedObject var mainViewModel = MainViewModel.instance
    
    @State private var scrollViewOffset: CGPoint = .zero
    @State private var animatableRects: [AnimatableRect: CGRect] = [:]
    @State private var animationSource: ShowDetailsSource = .recommended
    @State private var animationImageOrigin: CGRect?
    @State private var animationFavoriteButtonOrigin: CGRect?
    
    @State private var isTitleHidden = false
    
    var body: some View {
        TVMazeScrollView(title: "Shows", isTitleHidden: mainViewModel.isTitleHidden) {
            VStack(alignment: .leading, spacing: 20) {
                recommendedShows
                
                scheduledShows
            }
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
    
    var recommendedShows: some View {
        Group {
            if viewModel.isLoadingRecommendedShows {
                ProgressView()
                    .progressViewStyle(.circular)
                    .frame(maxWidth: .infinity)
                    .frame(height: RecommendedShowCard.height)
            } else if viewModel.recommendedShows.isEmpty {
                Text(verbatim: "No recommended shows found.")
                    .style(.boldBodyDefault, color: .white, alignment: .center)
                    .frame(maxWidth: .infinity)
                    .frame(height: RecommendedShowCard.height)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(viewModel.recommendedShows) { show in
                            RecommendedShowCard(model: show, isFavorite: favoritesService.binding(for: show.id))
                                .onTapGesture {
                                    showDetails(.init(from: show), source: .recommended, type: .recommendedShowCard)
                                }
                        }
                    }
                    .padding(.horizontal, 16)
                }
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
