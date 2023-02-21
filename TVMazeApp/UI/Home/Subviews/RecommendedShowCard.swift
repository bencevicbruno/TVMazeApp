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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            OnlineImage(model.posterURL) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: Self.width, height: Self.imageHeight)
                    .clipped()
                    .animatablePoster(id: model.id, type: .recommendedShowCard)
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
            }
            
            VStack(alignment: .leading, spacing: 6) {
                stars
                
                Text(verbatim: model.title)
                    .style(.smallCaption, color: .white, alignment: .leading)
                
                Spacer(minLength: 0)
            }
            .padding(8)
            .frame(height: Self.height - Self.imageHeight)
        }
        .frame(width: Self.width, height: Self.height)
        .background(Color.tvMazeDarkGray)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(alignment: .topTrailing) {
            FavoriteButton($isFavorite)
                .id(favoritesService.refreshToken ? 0 : 1)
                .animatablePoster(id: model.id, type: .favoriteButton)
        }
    }
    
    static let width = UIScreen.width * 0.4
    static let height = Self.width * 1.75
    static let imageHeight = Self.width * 1.25
}

private extension RecommendedShowCard {
    
    var fullStarsCount: Int {
        Int(ceil(model.rating / 2))
    }
    
    var emptyStarsCount: Int {
        5 - fullStarsCount
    }
    
    var hasHalfStar: Bool {
        let correctRange = model.rating / 2
        let wholePart = Int(correctRange)
        
        return (correctRange - Double(wholePart)) >= 0.5
    }
    
    var stars: some View {
        HStack(spacing: 4) {
            ForEach(1..<fullStarsCount, id: \.self) { _ in
                Image("icon_star_filled")
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .frame(size: 14)
                    .foregroundColor(Color.tvMazeYellow)
            }
            
            if hasHalfStar {
                Image("icon_star_half")
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .frame(size: 14)
                    .foregroundColor(Color.tvMazeYellow)
            }
        }
    }
}

struct RecommendedShowCard_Previews: PreviewProvider {
    
    static var previews: some View {
        HStack {
            RecommendedShowCard(model: .sample(), isFavorite: .constant(true))
            
            RecommendedShowCard(model: .sample(), isFavorite: .constant(false))
        }
    }
}
