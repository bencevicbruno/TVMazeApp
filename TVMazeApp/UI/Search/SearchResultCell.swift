//
//  SearchResultCell.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 13.02.2023..
//

import SwiftUI

struct SearchResultCell: View {
    
    let id = 1
    let title: String = "The placeholder panda eats bamboo"
    let year: Int = 2020
    let posterURL = "https://upload.wikimedia.org/wikipedia/commons/thumb/0/0f/Grosser_Panda.JPG/1200px-Grosser_Panda.JPG"
    let category: String = "Nature"
    let rating: Double = 8
    let categories = ["Panda", "Panda too"]
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                OnlineImage(posterURL) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(size: Self.imageSize)
                        .animatablePoster(id: id, type: .searchResultCard)
                        .clipped()
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                } placeholder: {
                    ProgressView()
                        .tint(.white)
                        .progressViewStyle(.circular)
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    Text(verbatim: title)
                        .style(.bodyDefault, color: .white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer(minLength: 0)
                    
                    stars
                        .padding(.bottom, 8)
                    
                    Text(verbatim: "Category: \(categories.joined(separator: ", "))")
                        .style(.smallCaption, color: .tvMazeLightGray)
                        .opacity(categories.isEmpty ? 0 : 1)
                        .lineLimit(1)
                }
            }
            .frame(height: Self.imageSize)
        }
        .padding(16)
        .frame(width: Self.width)
        .background(Color.tvMazeDarkGray)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal, 16)
    }
    
    static let width: CGFloat = UIScreen.width - 2 * 16
    static let height: CGFloat = Self.width
    
    static let imageSize: CGFloat = Self.width / 2.75 - 16
    
    static var imageMask: some View {
        RoundedRectangle(cornerRadius: 16)
    }
}

private extension SearchResultCell {
    
    var fullStarsCount: Int {
        Int(ceil(rating / 2))
    }
    
    var hasHalfStar: Bool {
        let correctRange = rating / 2
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

struct SearchResultCell_Previews: PreviewProvider {
    
    static var previews: some View {
        SearchResultCell()
    }
}
