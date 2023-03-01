//
//  ShowDetailsCastSection.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 17.02.2023..
//

import SwiftUI

struct ShowDetailsCastSection: View {
    
    private let contentState: ContentState
    
    init(contentState: ContentState) {
        self.contentState = contentState
    }
    
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
            
            Group {
                switch contentState {
                case .loading:
                    loadingStateContent
                case let .loaded(cast):
                    loadedStateContent(cast)
                }
            }
        }
        .padding(.vertical, 40)
        .background(backgroundGradient)
    }
    
    enum ContentState {
        case loading
        case loaded([CastMemberModel])
    }
}

private extension ShowDetailsCastSection {
    
    var loadingStateContent: some View {
        ProgressView()
            .progressViewStyle(.circular)
            .tint(.white)
            .frame(height: 100)
            .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder
    func loadedStateContent(_ cast: [CastMemberModel]) -> some View {
        if cast.isEmpty {
            Text(verbatim: "No cast data found.")
                .style(.boldCaptionDefualt, color: .white, alignment: .center)
                .frame(height: 100)
                .frame(maxWidth: .infinity)
        } else {
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
    }
    
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
            VStack(spacing: 10) {
                ShowDetailsCastSection(contentState: .loaded((1...3).map { .sample(withID: $0) }))
                
                ShowDetailsCastSection(contentState: .loading)
                
                ShowDetailsCastSection(contentState: .loaded([]))
            }
        }
    }
}
