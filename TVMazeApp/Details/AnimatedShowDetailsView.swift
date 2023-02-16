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
    
    static func sample(withID id: Int = -1) -> CastMemberModel {
        .init(id: id,
              name: "Johny Bravo",
              avatarURL: "https://c1-ebgames.eb-cdn.com.au/merchandising/images/packshots/680a399d0cf94d0b97a1c7791bcdc0e4_Large.jpg")
    }
}

struct AnimatedShowDetailsView: View {
    
    @ObservedObject var favoritesService = FavoritesService.instance
    
    private let model: ShowPrimaryInfoModel
    @Binding var isVisible: Bool
    private let originFrame: CGRect
    
    init(model: ShowPrimaryInfoModel, isVisible: Binding<Bool>, originFrame: CGRect) {
        self.model = model
        self._isVisible = isVisible
        self.originFrame = originFrame
    }
    
    @State private var didAppear = false
    @State private var navigationBarSize: CGSize = .zero
    
    var body: some View {
        ZStack {
            backgroundImage
            
            content

            detailsOverlay
        }
        .background(Color.tvMazeBlack.opacity(didAppear ? 1 : 0))
        .overlay(alignment: .topLeading) {
            FavoriteButton(favoritesService.binding(for: model.id))
                .offset(x: didAppear ? (UIScreen.width - 16 - FavoriteButton.defaultIconSize ) : originFrame.minX, y: didAppear ? (UIScreen.unsafeTopPadding + 0) : originFrame.minY)
            
            .edgesIgnoringSafeArea(.top)
        }
        .onAppear {
            withAnimation(.easeOut(duration: HomeView.transitionDuration)) {
                didAppear = true
            }
        }
        .frame(width: UIScreen.width)
//        .frame(width: UIScreen.width, height: UIScreen.height, alignment: .topLeading)
//        .clipped()
    }
    
    static let imageHeight = UIScreen.height * 2 / 3
}

private extension AnimatedShowDetailsView {
    
    var backgroundImage: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top, spacing: 0) {
                Image(uiImage: model.poster)
                    .resizable()
                    .scaledToFill()
                    .frame(width: didAppear ? UIScreen.width : originFrame.width, height: didAppear ? Self.imageHeight : originFrame.height)
                    .clipped()
                    .mask {
                        ZStack {
                            RoundedRectangle(cornerRadius: didAppear ? 0 : 16)
                            
                            Rectangle()
                                .padding(.top, 16)
                        }
                    }
                    .padding(.leading, didAppear ? 0 : originFrame.minX)
                    .padding(.top, didAppear ? 0 : originFrame.minY)
                
                Spacer()
            }
            
            Spacer()
        }
        .edgesIgnoringSafeArea(.all)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
    
    var content: some View {
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
                       
                    Text("The placeholder panda is eating all the bamboo again.")
                        .style(.header1, color: .white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 16)
                    
                    Text("What are we gonna do? What are we gonna do? What are we gonna do? What are we gonna do? What are we gonna do? What are we gonna do?")
                        .style(.bodyDefault, color: .white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 28)
                    
                    castSection
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .offset(y: didAppear ? 0 : UIScreen.height)
    }
    
    static let cast: [CastMemberModel] = (0...10).map { .sample(withID: $0) }
    
    var castSection: some View {
        ZStack {
            VStack(spacing: 0) {
                LinearGradient(colors: [.tvMazeBlack, .tvMazeGray], startPoint: .top, endPoint: .bottom)
                    .frame(height: 40)
                
                Color.tvMazeGray
                    .edgesIgnoringSafeArea(.all)
            }
            
            VStack(alignment: .leading, spacing: 24) {
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
                
                VStack(alignment: .leading, spacing: 24) {
                    ForEach(Self.cast) { member in
                        VStack(spacing: 0) {
                            HStack(spacing: 16) {
                                OnlineImage(member.avatarURL) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(size: 80)
                                        .clipShape(Circle())
                                } placeholder: {
                                    ProgressView()
                                }
                                
                                Text(verbatim: member.name)
                                    .style(.bodyLargeDefault, color: .tvMazeWhite)
                                    .lineLimit(2)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            
                            if let lastMember = Self.cast.last,
                               lastMember != member {
                                Color.tvMazeWhite
                                    .frame(height: 1)
                                    .padding(.top, 16)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
            .padding(.bottom, UIScreen.unsafeBottomPadding)
            .padding(.top, 44)
        }
    }
    
    var detailsOverlay: some View {
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
                                    }
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + HomeView.transitionDuration) {
                                        isVisible = false
                                    }
                                }
                            
                            Spacer()
                            
                            Color.clear
                                .frame(size: 40)
                        }
                        .padding(.horizontal, 16)
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
}

struct AnimatedShowDetailsView_Previews: PreviewProvider {
    
    static var previews: some View {
        AnimatedShowDetailsView(model: .init(from: RecommendedShowModel.sample()), isVisible: .constant(true), originFrame: .init(x: 50, y: 50, width: RecommendedShowCard.width, height: RecommendedShowCard.imageHeight))
            .background(.white)
    }
}
