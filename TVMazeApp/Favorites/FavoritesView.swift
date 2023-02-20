//
//  FavoritesView.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 13.02.2023..
//

import SwiftUI

struct FavoritesView: View {
    
    @StateObject var viewModel = FavoritesViewModel()
    
    @State private var scrollViewOffset: CGPoint = .zero
    
    @ObservedObject var favoritesService = FavoritesService.instance
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            title
            
            Group {
                if viewModel.canShowEmptyState && viewModel.favoriteShows.isEmpty {
                    noFavoriteContent
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if viewModel.favoriteShows.isEmpty {
                    Color.clear
                } else {
                    OffsettableScrollView(axes: .vertical, showsIndicator: false, offset: $scrollViewOffset) {
                        favoritesGrid
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.tvMazeBlack)
        .overlay(alignment: .top) {
            refreshLabel
        }
        .overlay {
            ProgressView()
                .progressViewStyle(.circular)
                .tint(.tvMazeWhite)
                .scaleEffect(x: 1.5, y: 1.5)
                .opacity(viewModel.isLoadingFavorites ? 1 : 0)
        }
        .onChange(of: scrollViewOffset) { newOffset in
            if newOffset.y > 1.5 * Self.refreshSecondThreshold {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    viewModel.refresh()
                }
            }
        }
    }
    
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
}

private extension FavoritesView {
    
    // MARK: - Title
    
    var title: some View {
        Text("Refresh")
            .style(.init(UIFont.merriweatherBold(size: titleFontSize)), color: .tvMazeWhite)
            .padding(.vertical, 8)
            .padding(.leading, titlePadding)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var titleFontSize: CGFloat {
        Self.titleSizeInterpolator.interpolate(value: -scrollViewOffset.y)
    }
    
    var titlePadding: CGFloat {
        Self.titlePaddingInterpolator.interpolate(value: -scrollViewOffset.y)
    }
    
    static let titleSizeInterpolator = SlopedStepRange(firstPoint: Self.titleFirstThreshold, firstValue: .textSizeDisplay, secondPoint: Self.titleSecondThreshold, secondValue: .textSizeLargeBody)
    
    static let titlePaddingInterpolator = SlopedStepRange(firstPoint: Self.titleFirstThreshold, firstValue: 16, secondPoint: Self.titleSecondThreshold, secondValue: (UIScreen.width - "Favorites".getWidth(using: .boldBodyDefault)) / 2)
    
    static let titleFirstThreshold = UIScreen.height / 4
    static let titleSecondThreshold = UIScreen.height / 2
    
    // MARK: - Refresh Label
    
    var refreshLabel: some View {
        Text("Release to refresh")
            .style(.init(UIFont.merriweatherBold(size: refreshFontSize)), color: .tvMazeWhite)
            .opacity(refreshOpacity)
            .foregroundColor(.white)
            .padding(16 + 2 * 8 + titleFontSize)
    }
    
    var refreshOpacity: CGFloat {
        Self.refreshLabelOpacityInterpolator.interpolate(value: scrollViewOffset.y)
    }
    
    var refreshFontSize: CGFloat {
        Self.refreshLabelSizeInterpolator.interpolate(value: scrollViewOffset.y)
    }
    
    static let refreshLabelOpacityInterpolator = SlopedStepRange(firstPoint: Self.refreshFirstThreshold, firstValue: 0, secondPoint: Self.refreshSecondThreshold, secondValue: 1)
    
    static let refreshLabelSizeInterpolator = SlopedStepRange(firstPoint: Self.refreshFirstThreshold, firstValue: .textSizeCaption, secondPoint: Self.refreshSecondThreshold, secondValue: .textSizeBody)
    
    static let refreshFirstThreshold: CGFloat = .textSizeCaption + 2 * 8 + 16
    static let refreshSecondThreshold: CGFloat = .textSizeBody + 2 * 8 + 16
    
    var favoritesGrid: some View {
        LazyVGrid(columns: [.init(.flexible(), spacing: 16), .init(.flexible())], alignment: .center, spacing: 16) {
            ForEach(viewModel.favoriteShows, id: \.self) { show in
                FavoriteShowCard(model: show, isFavorite: favoritesService.binding(for: show.id))
            }
        }
        .frame(width: UIScreen.width - 2 * 16)
        .padding(.horizontal, 16)
    }
}

struct FavoritesView_Previews: PreviewProvider {
    
    static var previews: some View {
        FavoritesView()
    }
}
