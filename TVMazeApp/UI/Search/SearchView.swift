//
//  SearchView.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 13.02.2023..
//

import SwiftUI

struct SearchView: View {
    
    @ObservedObject var mainViewModel = MainViewModel.instance
    @StateObject var viewModel = SearchViewModel()
    
    @FocusState var isFieldInFocus
    @State private var navigationBarSize: CGSize = .zero
    
    @State private var animatableRects: [AnimatableRect: CGRect] = [:]
    @State private var animationImageOrigin: CGRect?
    @State private var animationFavoriteButtonOrigin: CGRect?
    
    var body: some View {
        ZStack(alignment: .top) {
            resultsList
            
            VStack(spacing: 0) {
                navigationBar
                    .padding(.top, UIScreen.unsafeTopPadding)
                    .padding(.bottom, 8)
                    .background(Color.tvMazeBlack)
                
                searchField
                    .background(
                        Color.tvMazeBlack
                            .padding(.bottom, 25)
                    )
            }
            .readSize(into: $navigationBarSize)
            .offset(y: mainViewModel.isTitleHidden ? -navigationBarSize.height : 0)
            .animation(.linear(duration: AnimationUtils.toggleDetailsDuration), value: mainViewModel.isTitleHidden)
        }
        .edgesIgnoringSafeArea(.all)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.tvMazeBlack)
        .storeAnimatableRects(in: $animatableRects)
        .presentShowDetails(
            $viewModel.showPrimaryInfo, source: .search, imageOrigin: animationImageOrigin, favoriteButtonOrigin: animationFavoriteButtonOrigin)
        .onChange(of: isFieldInFocus) { isInFocus in
            mainViewModel.isSwipeGestureDisabled = isInFocus
        }
    }
}

private extension SearchView {
    
    var navigationBar: some View {
        Text("Search")
            .style(.display, color: .white)
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            .background(Color.tvMazeBlack)
    }
    
    var searchField: some View {
        HStack(spacing: 16) {
            TextField("Enter show name", text: $viewModel.searchText)
                .focused($isFieldInFocus)
                .foregroundColor(.tvMazeBlack)
                .font(.bodyDefault)
            
            Image("icon_cancel")
                .resizable()
                .scaledToFit()
                .frameAsIcon()
                .onTapGesture {
                    viewModel.searchText = ""
                }
        }
        .frame(height: 50)
        .padding(.leading, 16)
        .padding(.trailing, 8)
        .background(Color.tvMazeWhite)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black, radius: 16, y: 8)
        .padding(.horizontal, 16)
    }
    
    @ViewBuilder
    var resultsList: some View {
        if viewModel.searchText == "" {
            Text("Start typing to see results.")
                .style(.header1, color: .white, alignment: .center)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onTapGesture {
                    isFieldInFocus = false
                }
        }
        else if viewModel.searchedShows.isEmpty {
            Text("No results.")
                .style(.header1, color: .white, alignment: .center)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onTapGesture {
                    isFieldInFocus = false
                }
        } else {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.searchedShows) { model in
                        SearchResultCell(model: model)
                            .onTapGesture {
                                showDetails(.init(from: model))
                            }
                    }
                }
                .padding(.top, UIScreen.unsafeTopPadding + .textSizeDisplay + 16 + 8 + 50 + 32)
                .padding(.bottom, MainTabBar.height + MainTabBar.shadowSize)
            }
            .scrollDismissesKeyboard(.immediately)
        }
    }
    
    static let contentHeight: CGFloat = UIScreen.height - (UIScreen.unsafeTopPadding + .textSizeDisplay + 2 * 8 + 50 + 16 + MainTabBar.height)
    static let contentHeightWithoutNavigationBar: CGFloat = Self.contentHeight + UIScreen.unsafeTopPadding + .textSizeDisplay + 2 * 8 + 25
    
    func showDetails(_ details: ShowPrimaryInfoModel) {
        withAnimation(AnimationUtils.toggleBarsAnimation) {
            self.mainViewModel.isTabBarVisible = false
            self.mainViewModel.isTitleHidden = true
        }
        
        self.animationImageOrigin = animatableRects[.init(id: details.id, type: .searchResultCard)]
        self.animationFavoriteButtonOrigin = animatableRects[.init(id: details.id, type: .favoriteButton)]
        
        DispatchQueue.main.asyncAfter(deadline: .now() + AnimationUtils.toggleBarsDuration) {
            self.viewModel.showPrimaryInfo = details
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    
    static var previews: some View {
        SearchView()
    }
}
