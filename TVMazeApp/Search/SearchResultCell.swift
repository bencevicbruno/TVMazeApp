//
//  SearchResultCell.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 13.02.2023..
//

import SwiftUI

struct SearchResultCell: View {
    
    let title: String = "The placeholder panda eats bamboo"
    let year: Int = 2020
    let category: String = "Nature"
    
    var body: some View {
        HStack(spacing: 0) {
            Image("placeholder_panda")
                .resizable()
                .scaledToFill()
                .frame(size: Self.height)
                .clipped()
            
            VStack(alignment: .leading, spacing: 0) {
                Text(verbatim: title)
                    .style(.bodyDefault, color: .white)
                
                Spacer(minLength: 0)
                
                Text(verbatim: "\(year)")
                    .style(.captionDefault, color: .tvMazeLightGray)
                    .padding(.bottom, 2)
                
                Text(verbatim: "Categroy \(category)")
                    .style(.smallCaption, color: .tvMazeLightGray)
            }
            .padding(8)
            
            Spacer(minLength: 0)
        }
        .frame(width: Self.width, height: Self.height)
        .background(Color.tvMazeDarkGray)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal, 16)
    }
    
    static let width: CGFloat = UIScreen.width - 2 * 16
    static let height: CGFloat = Self.width * 0.3
}

struct SearchResultCell_Previews: PreviewProvider {
    
    static var previews: some View {
        SearchResultCell()
    }
}
