//
//  ShowEpisodeCard.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 01.03.2023..
//

import SwiftUI

struct ShowEpisodeCard: View {
    
    let model: ShowEpisodeModel
    
    var body: some View {
        VStack(spacing: 0) {
            OnlineImage(model.imageURL) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(.white)
            }
            .frame(width: Self.width, height: Self.width)
            .clipped()
            .overlay(alignment: .topLeading) {
                seasonEpisodeOverlay
            }
            .overlay(alignment: .bottom) {
                LinearGradient(colors: [.tvMazeDarkGray.opacity(0), .tvMazeDarkGray], startPoint: .top, endPoint: .bottom)
                    .frame(height: 20)
            }
        }
        .frame(width: Self.width, height: Self.height, alignment: .top)
        .background(Color.tvMazeDarkGray)
        .overlay(alignment: .bottomLeading) {
            VStack(alignment: .leading, spacing: 12) {
                Text(verbatim: model.title)
                    .style(.header2, color: .white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(verbatim: model.description)
                    .style(.captionDefault, color: .white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(3)
                
                HStack(spacing: 0) {
                    airdateLabel
                    
                    Spacer()
                    
                    RatingStars(rating: model.rating, size: .textSizeSmallCaption, addEmptySpacing: true)
                }
            }
            .padding(16)
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    static let width: CGFloat = UIScreen.width * 0.75
    static let height: CGFloat = Self.width * 1.5
}

private extension ShowEpisodeCard {
    
    var seasonEpisodeOverlay: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("\(model.season)/\(model.episode)")
                .style(.boldBodyDefault, color: .white)
                .padding(8)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.black.opacity(0.3))
            
            LinearGradient(colors: [.black.opacity(0.3), .clear], startPoint: .top, endPoint: .bottom)
                .frame(height: .textSizeCaption)
        }
    }
    
    var airdateLabel: some View {
        Text(Self.dateFormatter.string(from: model.airdate))
            .style(.boldSmallCaption, color: .tvMazeLightGray)
    }
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "mm/dd/YYYY"
        
        return formatter
    }()
}

struct ShowEpisodeCard_Previews: PreviewProvider {
    
    static var previews: some View {
        ShowEpisodeCard(model: .sample())
    }
}
