//
//  ShowDetailsEpisodesSection.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 01.03.2023..
//

import SwiftUI

struct ShowDetailsEpisodesSection: View {
    
    private let contentState: ContentState
    
    @State private var expandedSeasons: [Int]
    
    init(contentState: ContentState) {
        self.contentState = contentState
        
        switch contentState {
        case .loading:
            self._expandedSeasons = .init(initialValue: [])
        case let .loaded(episodes):
            self._expandedSeasons = .init(initialValue: episodes.keys.sorted())
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            episodesTitle
            
            switch contentState {
            case .loading:
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: ShowEpisodeCard.height / 2)
            case let .loaded(episodes):
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
        }
        .background(Color.tvMazeBlack)
    }
    
    enum ContentState {
        case loading
        case loaded([Int: [ShowEpisodeModel]])
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
            
            Rectangle()
                .fill(expandedSeasons.contains(seasonNumber) ? .green : .red)
                .frame(size: 40)
                .contentShape(Rectangle())
                .onTapGesture {
                    toggleSeason(seasonNumber)
                }
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
            ShowDetailsEpisodesSection(contentState: .loading)
            
            ShowDetailsEpisodesSection(contentState: .loaded([
                1: (1...10).map { .sample(withID: $0) },
                2: (1...8).map { .sample(withID: $0) },
                3: (1...4).map { .sample(withID: $0) },
                4: (1...2).map { .sample(withID: $0) }
            ]))
        }
    }
}
