//
//  FavoriteShowCard.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 14.02.2023..
//

import SwiftUI

struct FavoriteShowCard: View {
    
    let model: FavoriteShowModel
    @Binding var isFavorite: Bool
    
    var body: some View {
        OnlineImage(model.posterURL) { image in
            image
                .resizable()
                .scaledToFill()
                .frame(width: Self.width, height: Self.height)
                .clipped()
                .animatablePoster(id: model.id, type: .favoriteShowCard)
                .overlay(alignment: .topTrailing) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(isFavorite ? Color.tvMazeYellow : .clear)
                        .frame(size: 40)
                        .blur(radius: 12)
                }
        } placeholder: {
            ProgressView()
                .progressViewStyle(.circular)
                .tint(.white)
                .frame(width: Self.width, height: Self.height)
        } error: {
            NoPosterView()
                .frame(width: Self.width, height: Self.height)
        }
        .background(Color.tvMazeDarkGray)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(alignment: .topTrailing) {
            FavoriteButton($isFavorite)
                .animatablePoster(id: model.id, type: .favoriteButton)
        }
    }
    
    static let width = (UIScreen.width - 3 * 16) / 2
    static let height = Self.width * 4 / 3
    
    static var imageMask: some View {
        RoundedRectangle(cornerRadius: 16)
    }
}

struct FavoriteShowCard_Previews: PreviewProvider {
    
    static var previews: some View {
        FavoriteShowCard(model: .sample(), isFavorite: .constant(.random()))
    }
}
