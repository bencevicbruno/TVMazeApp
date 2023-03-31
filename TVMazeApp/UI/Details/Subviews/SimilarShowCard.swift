//
//  SimilarShowCard.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 29.03.2023..
//

import SwiftUI

struct SimilarShowCard: View {
    
    @ObservedObject var favoritesService = FavoritesService.instance
    
    let model: SimialarShowModel
    @Binding var isFavorite: Bool
    
    init(_ model: SimialarShowModel, isFavorite: Binding<Bool>) {
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
                    .animatablePoster(id: model.id, type: .similarShowCard)
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
            
            Text(verbatim: model.title)
                .style(.boldSmallCaption, color: .white, alignment: .center)
            .padding(4)
            .frame(height: Self.height - Self.imageHeight, alignment: .center)
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .frame(width: Self.width, height: Self.height, alignment: .topLeading)
        .background(Color.tvMazeDarkGray)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(alignment: .topTrailing) {
            FavoriteButton($isFavorite)
                .id(favoritesService.refreshToken ? 0 : 1)
                .animatablePoster(id: model.id, type: .favoriteButton)
        }
    }
    
    static let width: CGFloat = (UIScreen.width - 3 * 16) / 2
    static let height: CGFloat = Self.width * 1.5
    static let imageHeight: CGFloat = Self.width
    
    static var imageMask: some View {
        RoundedRectangle(cornerRadius: 16)
    }
}

struct SimilarShowCard_Previews: PreviewProvider {
    
    static var previews: some View {
        SimilarShowCard(.sample(), isFavorite: .constant(.random()))
    }
}
