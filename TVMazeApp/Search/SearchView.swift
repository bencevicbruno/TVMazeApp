//
//  SearchView.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 13.02.2023..
//

import SwiftUI

struct SearchView: View {
    
    @FocusState var isSearchFieldInFocus
    @State private var isSearchFieldVisible = false
    @State private var searchText = ""
    
    @State private var isLoading = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            navigationBar
                .overlay(alignment: .topLeading) {
                    if isSearchFieldVisible {
                        searchBar
                            .transition(.opacity.combined(with: .move(edge: .top)))
                    }
                }
            
            resultsList
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.tvMazeBlack)
        .preferredColorScheme(isSearchFieldVisible ? .light : .dark)
    }
}

private extension SearchView {
    
    var navigationBar: some View {
        HStack(spacing: 0) {
            Text("Search")
                .style(.display, color: .white)
                .opacity(isSearchFieldInFocus ? 0 : 1)
                .padding(.vertical, 8)
            
            Spacer()
            
            Image("icon_search")
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .frameAsIcon(imageSize: 32, iconSize: 40)
                .foregroundColor(.tvMazeWhite)
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation {
                        isSearchFieldVisible = true
                        isSearchFieldInFocus = true
                    }
                }
        }
        .padding(.horizontal, 16)
    }
    
    var searchBar: some View {
        HStack(spacing: 0) {
            Image("icon_search")
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .frameAsIcon(imageSize: 24, iconSize: 40)
                .foregroundColor(.tvMazeDarkGray)
            
            TextField("Hhuehuehue", text: $searchText)
                .focused($isSearchFieldInFocus)
                .transition(.opacity)
            
            Image("icon_cancel")
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .frameAsIcon(imageSize: 24, iconSize: 40)
                .foregroundColor(.tvMazeDarkGray)
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation {
                        isSearchFieldInFocus = false
                        isSearchFieldVisible = false
                    }
                }
        }
        .frame(height: 50)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .background(
            Color.white
                .padding(.bottom, 16)
        )
        .padding(.horizontal, 16)
    }
    
    var resultsList: some View {
        ScrollView(.vertical, showsIndicators: false) {
            if isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
            }
            
            LazyVStack(alignment: .leading, spacing: 20) {
                ForEach(1...10, id: \.self) { _ in
                    SearchResultCell()
                }
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    
    static var previews: some View {
        SearchView()
    }
}
