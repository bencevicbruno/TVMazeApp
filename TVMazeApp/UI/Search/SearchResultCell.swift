//
//  SearchResultCell.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 13.02.2023..
//

import SwiftUI

struct SearchResultCell: View {
    
    @ObservedObject var favoritesService = FavoritesService.instance
    
    let model: SearchShowModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            OnlineImage(model.posterURL) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: Self.width, height: Self.imageHeight)
                    .animatablePoster(id: model.id, type: .searchResultCard)
                    .clipped()
                    .overlay(alignment: .topTrailing) {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(isFavorite ? Color.tvMazeYellow : .clear)
                            .frame(size: 40)
                            .blur(radius: 12)
                    }
            } placeholder: {
                ProgressView()
                    .tint(.white)
                    .progressViewStyle(.circular)
                    .frame(width: Self.width, height: Self.imageHeight)
            }
            
            VStack(alignment: .leading) {
                Text(verbatim: model.title)
                    .style(.header1, color: .white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 8)
                
                if !model.categories.isEmpty {
                    Text(verbatim: "Category: \(model.categories.joined(separator: ", "))")
                        .style(.bodyDefault, color: .white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 12)
                }
                
                stars
            }
            .padding(16)
        }
        .frame(width: Self.width)
        .background(Color.tvMazeDarkGray)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(alignment: .topTrailing) {
            FavoriteButton(favoritesService.binding(for: model.id))
                .id(favoritesService.refreshToken ? 0 : 1)
                .animatablePoster(id: model.id, type: .favoriteButton)
        }
    }
    
    static let width: CGFloat = UIScreen.width - 2 * 16
    static let imageHeight: CGFloat = Self.width
    
    static var imageMask: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                
            Rectangle()
                .padding(.top, 16)
        }
    }
    
    var isFavorite: Bool {
        favoritesService.isFavorite(model.id)
    }
}

private extension SearchResultCell {
    
    var fullStarsCount: Int {
        Int(ceil(model.rating / 2))
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
                    .frame(size: 24)
                    .foregroundColor(Color.tvMazeYellow)
            }
            
            if hasHalfStar {
                Image("icon_star_half")
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .frame(size: 24)
                    .foregroundColor(Color.tvMazeYellow)
            }
        }
    }
}

struct SearchResultCell_Previews: PreviewProvider {
    
    static var previews: some View {
        SearchResultCell(model: .sample())
    }
}
