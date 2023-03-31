//
//  ShowDetailsEpisodesSection.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 01.03.2023..
//

import SwiftUI

struct ShowDetailsEpisodesSection: View {
    
    private let episodes: [Int: [ShowEpisodeModel]]
    
    @State private var expandedSeasons: [Int] = []
    
    init(episodes: [Int: [ShowEpisodeModel]]) {
        self.episodes = episodes
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            episodesTitle
            
            LazyVStack(alignment: .leading, spacing: 20) {
                ForEach(episodes.keys.sorted(), id: \.self) { seasonNumber in
                    VStack(spacing: 16) {
                        seasonsHeader(seasonNumber)
                        .padding(.horizontal, 16)
                        
                        if expandedSeasons.contains(seasonNumber) {
                            seasonSection(episodes: episodes[seasonNumber] ?? [])
                                .transition(.opacity)
                        }
                    }
                }
            }
        }
        .background(Color.tvMazeBlack)
    }
}

private extension ShowDetailsEpisodesSection {
    
    func toggleSeason(_ number: Int) {
        withAnimation {
            if expandedSeasons.contains(number) {
                expandedSeasons.removeAll(where: { $0 == number })
            } else {
                expandedSeasons.append(number)
            }
        }
    }
    
    var episodesTitle: some View {
        HStack(spacing: 24) {
            Rectangle()
                .fill(Color.tvMazeWhite)
                .frame(height: 2)
            
            Text(verbatim: "Episodes")
                .style(.header1, color: .tvMazeWhite)
                .layoutPriority(1)
            
            Rectangle()
                .fill(Color.tvMazeWhite)
                .frame(height: 2)
        }
        .padding(.horizontal, 16)
    }
    
    func seasonsHeader(_ seasonNumber: Int) -> some View {
        HStack(spacing: 0) {
            Text(verbatim: "Season #\(seasonNumber)")
                .style(.header2, color: .tvMazeWhite)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            
            Image("icon_chevron_down")
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .frameAsIcon()
                .rotationEffect(.degrees(expandedSeasons.contains(seasonNumber) ? 180 : 0))
        }
        .contentShape(Rectangle())
        .onTapGesture {
            toggleSeason(seasonNumber)
        }
    }
    
    func seasonSection(episodes: [ShowEpisodeModel]) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 16) {
                ForEach(episodes) { model in
                    ShowEpisodeCard(model: model)
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

struct ShowDetailsEpisodesSection_Previews: PreviewProvider {
    
    static var previews: some View {
        ScrollView(.vertical) {
            ShowDetailsEpisodesSection(episodes: [
                1: (1...10).map { .sample(withID: $0) },
                2: (1...8).map { .sample(withID: $0) },
                3: (1...4).map { .sample(withID: $0) },
                4: (1...2).map { .sample(withID: $0) }
            ])
        }
    }
}
