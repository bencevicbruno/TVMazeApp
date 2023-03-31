//
//  ShowDetailsSimilarShowsSection.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 29.03.2023..
//

import SwiftUI

struct ShowDetailsSimilarShowsSection: View {
    
    @ObservedObject var mainViewModel = MainViewModel.instance
    @ObservedObject var favoritesService = FavoritesService.instance
    
    private let shows: [SimialarShowModel]
    
    @State private var animatableRects: [AnimatableRect: CGRect] = [:]
    @Binding var animationImageOrigin: CGRect?
    @Binding var animationFavoriteButtonOrigin: CGRect?
    @Binding var similarShowPrimaryInfo: ShowPrimaryInfoModel?
    
    init(_ shows: [SimialarShowModel], animationImageOrigin: Binding<CGRect?>, animationFavoriteButtonOrigin: Binding<CGRect?>, similarShowPrimaryInfo: Binding<ShowPrimaryInfoModel?>) {
        self.shows = shows
        self._animationImageOrigin = animationImageOrigin
        self._animationFavoriteButtonOrigin = animationFavoriteButtonOrigin
        self._similarShowPrimaryInfo = similarShowPrimaryInfo
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            HStack(spacing: 24) {
                Rectangle()
                    .fill(Color.tvMazeWhite)
                    .frame(height: 2)
                
                Text(verbatim: "Similar")
                    .style(.header1, color: .tvMazeWhite)
                
                Rectangle()
                    .fill(Color.tvMazeWhite)
                    .frame(height: 2)
            }
            .padding(.horizontal, 16)
            
            similarShowsGrid
                .padding(.horizontal, 16)
        }
        .padding(.vertical, 40)
        .storeAnimatableRects(in: $animatableRects)
    }
}

private extension ShowDetailsSimilarShowsSection {
    
    var similarShowsGrid: some View {
        LazyVGrid(columns: [.init(.fixed(SimilarShowCard.width), spacing: 16), .init(.fixed(SimilarShowCard.width))], spacing: 16) {
            ForEach(shows) { show in
                SimilarShowCard(show, isFavorite: favoritesService.binding(for: show.id))
                    .onTapGesture {
                        showDetails(.init(from: show))
                    }
            }
        }
    }
    
    func showDetails(_ details: ShowPrimaryInfoModel) {
        withAnimation(AnimationUtils.toggleBarsAnimation) {
            self.mainViewModel.isTabBarVisible = false
            self.mainViewModel.isTitleHidden = true
        }
        
        self.animationImageOrigin = animatableRects[.init(id: details.id, type: .similarShowCard)]
        self.animationFavoriteButtonOrigin = animatableRects[.init(id: details.id, type: .favoriteButton)]
        
        DispatchQueue.main.asyncAfter(deadline: .now() + AnimationUtils.toggleBarsDuration) {
            self.similarShowPrimaryInfo = details
        }
    }
}

struct ShowDetailsSimilarShowsSection_Previews: PreviewProvider {
    
    static var previews: some View {
        ScrollView(.vertical) {
            ShowDetailsSimilarShowsSection((0...10).map { .sample(withID: $0) }, animationImageOrigin: .constant(.zero), animationFavoriteButtonOrigin: .constant(.zero), similarShowPrimaryInfo: .constant(.none))
                .background(Color.tvMazeBlack)
        }
    }
}
