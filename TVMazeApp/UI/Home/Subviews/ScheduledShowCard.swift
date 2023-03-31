//
//  ScheduledShowCard.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 13.02.2023..
//

import SwiftUI

struct ScheduledShowCard: View {
    
    let model: ScheduledShowModel
    
    var body: some View {
        HStack(spacing: 0) {
            OnlineImage(model.posterURL) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(size: Self.height)
                    .clipped()
            } placeholder: {
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(.tvMazeWhite)
                    .frame(size: Self.height)
            } error: {
                NoPosterView()
                    .frame(size: Self.height)
            }
            .animatableRect(id: model.id, type: .scheduledShowCard)
            
            VStack(alignment: .leading, spacing: 0) {
                Text(verbatim: model.title)
                    .style(.boldSmallCaption, color: .white, alignment: .leading)
                
                Spacer(minLength: 0)
                
                Text(verbatim: "21:00h")
                    .style(.label, color: .tvMazeLightGray)
                    .padding(.bottom, 2)
                
                Text(verbatim: "Category: \(categories)")
                    .style(.smallCaption, color: .tvMazeLightGray)
                    .opacity(model.categories.isEmpty ? 0 : 1)
                    .lineLimit(1)
            }
            .padding(8)
        }
        .frame(width: Self.width, height: Self.height, alignment: .leading)
        .background(Color.tvMazeDarkGray)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    static let width = UIScreen.width - 2 * 16
    static let height = Self.width * 0.3
    
    static var imageMask: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
            
            Rectangle()
                .padding(.leading, 16)
        }
    }
}

private extension ScheduledShowCard {
    
    var categories: String {
        model.categories.joined(separator: ", ")
    }
}

struct ScheduledShowCard_Previews: PreviewProvider {
    
    static var previews: some View {
        ScheduledShowCard(model: .sample())
    }
}
