//
//  ShowDetailsCastSection.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 17.02.2023..
//

import SwiftUI

struct ShowDetailsCastSection: View {
    
    let cast: [CastMemberModel]
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            HStack(spacing: 24) {
                Rectangle()
                    .fill(Color.tvMazeWhite)
                    .frame(height: 2)
                
                Text(verbatim: "Cast")
                    .style(.header1, color: .tvMazeWhite)
                
                Rectangle()
                    .fill(Color.tvMazeWhite)
                    .frame(height: 2)
            }
            .padding(.horizontal, 16)
            
            LazyVStack(alignment: .leading, spacing: 0) {
                ForEach(cast) { member in
                    VStack(spacing: 0) {
                        CastMemberCell(model: member)
                        
                        if member != cast.last {
                            Color.tvMazeWhite
                                .frame(height: 1)
                                .padding(.horizontal, 16)
                        }
                    }
                }
            }
        }
        .padding(.vertical, 40)
        .background(backgroundGradient)
    }
}

private extension ShowDetailsCastSection {
    
    var backgroundGradient: some View {
        VStack(spacing: 0) {
            LinearGradient(colors: [.tvMazeGray.opacity(0), .tvMazeGray], startPoint: .top, endPoint: .bottom)
                .frame(height: 40)
            
            Color.tvMazeGray
            
            LinearGradient(colors: [.tvMazeGray, .tvMazeGray.opacity(0)], startPoint: .top, endPoint: .bottom)
            
                .frame(height: 40)
        }
    }
}

struct ShowDetailsCastSection_Previews: PreviewProvider {
    
    static var previews: some View {
        ScrollView(.vertical) {
            ShowDetailsCastSection(cast: (1...10).map { .sample(withID: $0) })
        }
    }
}
