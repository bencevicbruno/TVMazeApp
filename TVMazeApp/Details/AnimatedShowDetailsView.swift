//
//  ShowDetailsView.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 15.02.2023..
//

import SwiftUI

struct CastMemberModel: Identifiable, Hashable {
    let id: Int
    let name: String
    let avatarURL: String
    let roleName: String
    
    static func sample(withID id: Int = -1) -> CastMemberModel {
        .init(id: id,
              name: "Johny Bravo",
              avatarURL: "https://c1-ebgames.eb-cdn.com.au/merchandising/images/packshots/680a399d0cf94d0b97a1c7791bcdc0e4_Large.jpg",
              roleName: "Himself")
    }
}

struct OffsetToRectModifier: ViewModifier {
    
    private let rect: CGRect?
    
    @State private var currentRect: CGRect = .zero
    
    init(rect: CGRect?) {
        self.rect = rect
    }
    
    func body(content: Content) -> some View {
        content
            .offset(x: rect == nil ? 0 : (rect!.minX - currentRect.minX),
                    y: rect == nil ? 0 : (rect!.minY - currentRect.minY))
            .readRect(into: $currentRect)
    }
}

extension View {
    
    func offset(to rect: CGRect?) -> some View {
        self.modifier(OffsetToRectModifier(rect: rect))
    }
}

struct AnimatedShowDetailsView: View {
    
    @ObservedObject var favoritesService = FavoritesService.instance
    @ObservedObject var mainViewModel = MainViewModel.instance
    
    @Binding var isVisible: Bool
    private let imageOrigin: CGRect
    private let favoriteButtonOrigin: CGRect?
    
    @StateObject var viewModel: ShowDetailsViewModel
    
    init(model: ShowPrimaryInfoModel, isVisible: Binding<Bool>, imageOrigin: CGRect, favoriteButtonOrigin: CGRect? = nil) {
        self._viewModel = .init(wrappedValue: .init(model: model))
        self._isVisible = isVisible
        self.imageOrigin = imageOrigin
        self.favoriteButtonOrigin = favoriteButtonOrigin
    }
    
    @State private var didAppear = false
    @State private var navigationBarSize: CGSize = .zero
    
    @State private var castModel: ShowCastModel?
    
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
            withAnimation(.easeOut(duration: HomeView.transitionDuration)) {
                didAppear = true
            }
        }
    }
    
    static let imageHeight = UIScreen.height * 2 / 3
    
    var isFavorite: Bool {
        favoritesService.isFavorite(viewModel.model.id)
    }
}

private extension AnimatedShowDetailsView {
    
    // MARK: Navigation Bar
    
    var navigationBar: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                Rectangle()
                    .fill(.black.opacity(0.4))
                    .frame(maxWidth: .infinity)
                    .frame(height: UIScreen.unsafeTopPadding)
                
                Color.black.opacity(0.4)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .overlay {
                        HStack(spacing: 0) {
                            Image("icon_back")
                                .resizable()
                                .renderingMode(.template)
                                .scaledToFit()
                                .foregroundColor(.white)
                                .frameAsIcon()
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    withAnimation(.easeOut(duration: HomeView.transitionDuration)) {
                                        didAppear = false
                                        mainViewModel.isTabBarVisible = true
                                    }
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + HomeView.transitionDuration) {
                                        isVisible = false
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
                    }
                
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
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top, spacing: 0) {
                Image(uiImage: viewModel.model.poster)
                    .resizable()
                    .scaledToFill()
                    .frame(width: didAppear ? UIScreen.width : imageOrigin.width, height: didAppear ? Self.imageHeight : imageOrigin.height)
                    .clipped()
                    .mask {
                        if favoriteButtonOrigin == nil {
                            ZStack {
                                RoundedRectangle(cornerRadius: didAppear ? 0 : 16)
                                
                                Rectangle()
                                    .padding(.leading, 16)
                            }
                        } else {
                            ZStack {
                                RoundedRectangle(cornerRadius: didAppear ? 0 : 16)
                                
                                Rectangle()
                                    .padding(.top, 16)
                            }
                        }
                    }.mask {
                        VStack(spacing: 0) {
                            Color.black
                            
                            LinearGradient(colors: [.black, .clear], startPoint: .top, endPoint: .bottom)
                                .frame(height: didAppear ? 40 : 0)
                        }
                    }
                    .offset(to: didAppear ? nil : imageOrigin)
                
                Spacer()
            }
            
            Spacer()
        }
        .edgesIgnoringSafeArea(.all)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
    
    // MARK: Show Details
    
    var showDetails: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ZStack {
                VStack(spacing: 0) {
                    Color.clear
                        .frame(height: Self.imageHeight - 100)
                    
                    LinearGradient(colors: [.clear, .tvMazeBlack], startPoint: .top, endPoint: .bottom)
                        .frame(height: 100)
                    
                    Color.tvMazeBlack
                        .frame(maxHeight: .infinity)
                }
                
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
                    
                    ShowDetailsCastSection(contentState: viewModel.castContentState)
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .offset(y: didAppear ? 0 : UIScreen.height)
    }
}

struct AnimatedShowDetailsView_Previews: PreviewProvider {
    
    static var previews: some View {
        AnimatedShowDetailsView(model: .init(from: RecommendedShowModel.sample()),
                                isVisible: .constant(true),
                                imageOrigin: .init(x: 50, y: 50, width: RecommendedShowCard.width, height: RecommendedShowCard.imageHeight))
        .background(.white)
    }
}
