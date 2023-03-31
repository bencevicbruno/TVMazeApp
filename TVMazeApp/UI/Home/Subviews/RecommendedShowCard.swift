//
//  RecommendedShowCard.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 13.02.2023..
//

import SwiftUI

struct RecommendedShowCard: View {
    
    @ObservedObject var favoritesService = FavoritesService.instance
    
    let model: RecommendedShowModel
    @Binding var isFavorite: Bool
    
    init(model: RecommendedShowModel, isFavorite: Binding<Bool>) {
        self.model = model
        self._isFavorite = isFavorite
    }
    
    let scaleInterpolator = TruncatedTriangleInterpolator(firstLowThreshold: UIScreen.width * 3 / 16, firstHighThreshold: UIScreen.width * 7 / 16, secondHighThreshold: UIScreen.width * 9 / 16, secondLowThreshold: UIScreen.width * 13 / 16, minValue: 0.9, maxValue: 1.0)
    
    var body: some View {
        GeometryReader { proxy in
            VStack(alignment: .leading, spacing: 0) {
                OnlineImage(model.posterURL) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: Self.width, height: Self.imageHeight)
                        .clipped()
                        .overlay(alignment: .topTrailing) {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(isFavorite ? Color.tvMazeYellow : .clear)
                                .frame(size: 40)
                                .blur(radius: 12)
                        }
                } placeholder: {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(.tvMazeWhite)
                        .frame(width: Self.width, height: Self.imageHeight)
                } error: {
                    NoPosterView()
                        .frame(width: Self.width, height: Self.imageHeight)
                }
                .animatableRect(id: model.id, type: .recommendedShowCard)
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(verbatim: model.title)
                        .style(.header1, color: .white, alignment: .center)
                        .frame(maxWidth: .infinity)
                    
                    Spacer(minLength: 0)
                    
                    RatingStars(rating: model.rating ?? 10)
                        .opacity(model.rating == nil ? 0 : 1)
                        .frame(maxWidth: .infinity)
                }
                .padding(16)
                .frame(height: Self.height - Self.imageHeight)
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
            .background(Color.tvMazeDarkGray)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(alignment: .topTrailing) {
                FavoriteButton($isFavorite)
                    .id(favoritesService.refreshToken ? 0 : 1)
                    .animatableRect(id: model.id, type: .favoriteButton)
            }
            .allowsHitTesting(scaleInterpolator.interpolate(proxy.frame(in: .global).midX) == 1)
            .scaleEffect(x: scaleInterpolator.interpolate(proxy.frame(in: .global).midX), y: scaleInterpolator.interpolate(proxy.frame(in: .global).midX))
        }
        .frame(width: Self.width, height: Self.height)
        
    }
    
    static let width = UIScreen.width - 64 * 2
    static let height = Self.imageHeight + 2 * 16 + 2 * .textSizeHeader1 + 48 + 6
    static let imageHeight = Self.width * 1.25
    
    static var imageMask: some View {
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 16)
            
            Rectangle()
                .padding(.top, 10)
        }
    }
}

struct RecommendedShowCard_Previews: PreviewProvider {
    
    static var previews: some View {
        RecommendedShowCard(model: .sample(), isFavorite: .constant(true))
        
    }
}
