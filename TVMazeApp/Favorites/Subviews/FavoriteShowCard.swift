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
        VStack(alignment: .leading, spacing: 0) {
            OnlineImage(model.posterURL) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(size: Self.width)
                    .clipped()
                    
            } placeholder: {
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(.white)
                    .frame(size: Self.width)
            }
            .overlay(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(isFavorite ? Color.tvMazeYellow : .clear)
                    .frame(size: 40)
                    .blur(radius: 12)
            }
            
            Text(verbatim: model.title)
                .style(.smallCaption, color: .white, alignment: .leading)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding(8)
        }
        .frame(width: Self.width, height: Self.height)
        .background(Color.tvMazeDarkGray)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(alignment: .topLeading) {
            FavoriteButton($isFavorite)
        }
    }
    
    static let width = (UIScreen.width - 3 * 16) / 2
    static let height = Self.width * 4 / 3
}

struct FavoriteShowCard_Previews: PreviewProvider {
    
    static var previews: some View {
        FavoriteShowCard(model: .sample(), isFavorite: .constant(.random()))
    }
}
