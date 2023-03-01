//
//  RatingStars.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 25.02.2023..
//

import SwiftUI

struct RatingStars: View {
    
    private let rating: Double
    private let size: CGFloat
    private let addEmptySpacing: Bool
    
    init(rating: Double, size: CGFloat = 24, addEmptySpacing: Bool = false) {
        self.rating = rating
        self.size = size
        self.addEmptySpacing = addEmptySpacing
    }
    
    var body: some View {
        HStack(spacing: 4) {
            if fullStarsCount != 0 {
                ForEach(0..<fullStarsCount, id: \.self) { _ in
                    Image("icon_star_filled")
                        .resizable()
                        .renderingMode(.template)
                        .scaledToFit()
                        .frame(size: size)
                        .foregroundColor(Color.tvMazeYellow)
                }
            }
            
            if hasHalfStar {
                Image("icon_star_half")
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .frame(size: size)
                    .foregroundColor(Color.tvMazeYellow)
            }
            
            if addEmptySpacing {
                ForEach(1..<(5 - fullStarsCount), id: \.self) { index in
                    Color.clear
                        .frame(size: size)
                }
            }
        }
    }
}

private extension RatingStars {
    
    var fullStarsCount: Int {
        Int(floor(rating / 2))
    }
    
    var hasHalfStar: Bool {
        let correctRange = rating / 2
        let wholePart = Int(correctRange)
        
        return (correctRange - Double(wholePart)) >= 0.5
    }
}

struct RatingStars_Previews: PreviewProvider {
    
    static var previews: some View {
        RatingStars(rating: 5)
    }
}
