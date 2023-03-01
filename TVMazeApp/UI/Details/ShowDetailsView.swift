//
//  ShowDetailsView.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 15.02.2023..
//

import SwiftUI

struct ShowDetailsView: View {
    
    @ObservedObject var favoritesService = FavoritesService.instance
    @ObservedObject var mainViewModel = MainViewModel.instance
    
    @Binding var isVisible: Bool
    private let source: ShowDetailsSource
    private let imageOrigin: CGRect
    private let favoriteButtonOrigin: CGRect?
    
    @StateObject var viewModel: ShowDetailsViewModel
    
    @State private var didAppear = false
    @State private var navigationBarSize: CGSize = .zero
    
    init(model: ShowPrimaryInfoModel, isVisible: Binding<Bool>, source: ShowDetailsSource, imageOrigin: CGRect, favoriteButtonOrigin: CGRect? = nil) {
        self._viewModel = .init(wrappedValue: .init(model: model))
        self._isVisible = isVisible
        self.source = source
        self.imageOrigin = imageOrigin
        self.favoriteButtonOrigin = favoriteButtonOrigin
    }
    
    var body: some View {
        ZStack {
            backgroundImage
            
            showDetails
            
            navigationBar
        }
        .edgesIgnoringSafeArea(.all)
        .frame(width: UIScreen.width)
        .background(Color.tvMazeBlack.opacity(didAppear ? 1 : 0))
        .onAppear {
            withAnimation(AnimationUtils.showDetailsAnimation) {
                didAppear = true
            }
        }
        .allowsHitTesting(didAppear)
    }
    
    static let imageHeight = UIScreen.height * 2 / 3
    
    var isFavorite: Bool {
        favoritesService.isFavorite(viewModel.model.id)
    }
}

private extension ShowDetailsView {
    
    // MARK: Navigation Bar
    
    var navigationBar: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Image("icon_back")
                        .resizable()
                        .renderingMode(.template)
                        .scaledToFit()
                        .foregroundColor(.white)
                        .frameAsIcon()
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation(AnimationUtils.hideDetailsAnimation) {
                                didAppear = false
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + AnimationUtils.toggleDetailsDuration) {
                                isVisible = false
                                
                                withAnimation(AnimationUtils.toggleBarsAnimation) {
                                    self.mainViewModel.isTabBarVisible = true
                                    self.mainViewModel.isTitleHidden = false
                                }
                            }
                        }
                    
                    Spacer()
                    
                    FavoriteButton(favoritesService.binding(for: viewModel.model.id))
                        .background((isFavorite ? Color.tvMazeYellow : .clear).blur(radius: didAppear ? 16 : 8))
                        .scaleEffect(x: didAppear ? 1 : (favoriteButtonOrigin == nil ? 0 : 1), y: didAppear ? 1 : (favoriteButtonOrigin == nil ? 0 : 1), anchor: .center)
                        .offset(to: (didAppear || favoriteButtonOrigin == nil) ? nil : favoriteButtonOrigin!)
                        .offset(y: didAppear ? 0 : navigationBarSize.height)
                        .opacity(favoriteButtonOrigin == nil ? (didAppear ? 1 : 0) : 1)
                        
                }
                .padding(.horizontal, 24)
                .frame(height: 50)
                .padding(.top, UIScreen.unsafeTopPadding)
                .background(Color.black.opacity(0.4))
                
                LinearGradient(colors: [.black.opacity(0.4), .clear], startPoint: .top, endPoint: .bottom)
                    .frame(height: 40)
                
                Spacer()
            }
            .frame(width: UIScreen.width, height: Self.imageHeight)
            .edgesIgnoringSafeArea(.all)
            
            
            Spacer()
        }
        .readSize(into: $navigationBarSize)
        .offset(y: didAppear ? 0 : -navigationBarSize.height)
    }
    
    // MARK: Background Image
    
    var backgroundImage: some View {
        Image(uiImage: viewModel.model.poster)
            .resizable()
            .scaledToFill()
            .frame(width: didAppear ? UIScreen.width : imageOrigin.width, height: didAppear ? Self.imageHeight : imageOrigin.height)
            .clipped()
            .mask {
                switch source {
                case .recommended:
                    RecommendedShowCard.imageMask
                case .scheduled:
                    ScheduledShowCard.imageMask
                case .search:
                    SearchResultCell.imageMask
                case .favorites:
                    FavoriteShowCard.imageMask
                }
            }
            .mask {
                VStack(spacing: 0) {
                    Color.black
                        .frame(width: UIScreen.width)
                    
                    LinearGradient(colors: [.black, .clear], startPoint: .top, endPoint: .bottom)
                        .frame(width: UIScreen.width, height: didAppear ? 40 : 0)
                }
            }
            .offset(to: didAppear ? nil : imageOrigin)
            .edgesIgnoringSafeArea(.all)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
    
    // MARK: Show Details
    
    var showDetails: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                Color.clear
                    .frame(height: Self.imageHeight - .textSizeHeader1)
                
                Text(verbatim: viewModel.model.title)
                    .style(.header1, color: .white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                
                Text(verbatim: viewModel.model.description)
                    .style(.bodyDefault, color: .white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 28)
                
                ShowDetailsEpisodesSection(contentState: viewModel.episodesContentState)
                
                ShowDetailsCastSection(contentState: viewModel.castContentState)
            }
            .padding(.bottom, UIScreen.unsafeBottomPadding)
            .background(
                VStack(spacing: 0) {
                    Color.clear
                        .frame(height: Self.imageHeight - 100)
                    
                    LinearGradient(colors: [.clear, .tvMazeBlack], startPoint: .top, endPoint: .bottom)
                        .frame(height: 100)
                    
                    Color.tvMazeBlack
                        .frame(maxHeight: .infinity)
                }
            )
        }
        .edgesIgnoringSafeArea(.all)
        .offset(y: didAppear ? 0 : UIScreen.height)
    }
}

struct ShowDetailsView_Previews: PreviewProvider {
    
    static var previews: some View {
        ShowDetailsView(model: .init(from: RecommendedShowModel.sample()),
                                isVisible: .constant(true),
                                source: .favorites,
                                imageOrigin: .init(x: 50, y: 50, width: RecommendedShowCard.width, height: RecommendedShowCard.imageHeight))
        .background(.white)
    }
}
