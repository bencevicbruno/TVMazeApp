//
//  HomeView.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 12.02.2023..
//

import SwiftUI

extension View {
    
//    @ViewBuilder
//    func presentShowDetails(_ binding: Binding<ShowPrimaryInfoModel?>) -> some View {
//        self.overlay {
//            if let model = binding.wrappedValue {
//                ShowDetailsView(model: model, isVisible: .init(get: {
//                    binding.wrappedValue != nil
//                }, set: { newValue in
//                    if !newValue {
//                        binding.wrappedValue = nil
//                    }
//                }))
//            }
//        }
//    }
    
    func presentShowDetails(_ binding: Binding<ShowPrimaryInfoModel?>, fromRect originRect: CGRect) -> some View {
        ZStack {
            self
            
            if let model = binding.wrappedValue {
                AnimatedShowDetailsView(
                    model: model,
                    isVisible: .init(
                        get: {
                            binding.wrappedValue != nil
                        }, set: { visible in
                            if !visible {
                                binding.wrappedValue = nil
                            }
                        }),
                    originFrame: originRect)
            }
        }
    }
}

struct HomeView: View {
    
    @StateObject var viewModel = HomeViewModel()
    
    @ObservedObject var favoritesService = FavoritesService.instance
    
    @State private var recommendedRects = [Int: CGRect]()
    @State private var scrollViewOffset: CGPoint = .zero
    
    var body: some View {
        ZStack(alignment: .top) {
            OffsettableScrollView(axes: .vertical, showsIndicator: false, offset: $scrollViewOffset) {
                VStack(alignment: .leading, spacing: 20) {
                    recommendedShows
                    
                    scheduledShows
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.top, 2 * 8 + titleFontSize)
            .presentShowDetails($viewModel.showPrimaryInfo, fromRect: recommendedRects[viewModel.showPrimaryInfo?.id ?? 0]?.reducingHeight(RecommendedShowCard.height - RecommendedShowCard.imageHeight) ?? .zero)
            
            VStack(spacing: 0) {
                title
                    .offset(y: viewModel.showPrimaryInfo == nil ? 0 : -(.textSizeDisplay + 2 * 8 + UIScreen.unsafeTopPadding))
                    .animation(.easeOut(duration: Self.transitionDuration / 5), value: viewModel.showPrimaryInfo)
                
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.tvMazeBlack)
        .overlay(alignment: .top) {
            refreshLabel
        }
        .onChange(of: scrollViewOffset) { newOffset in
            if newOffset.y > 1.5 * Self.refreshThreshold {
                viewModel.shouldRefreshOnScrollEnd = true
            }
            
            if newOffset.y <= 10 {
                viewModel.refresh()
            }
        }
        
    }
    
    static let scrollViewFirstThreshold: CGFloat = RecommendedShowCard.height * 0.95
    static let scrollViewSecondThreshold: CGFloat = RecommendedShowCard.height * 1.15
    
    static let refreshThreshold = Self.scrollViewFirstThreshold / 3
    static let refreshMinSize = CGFloat.textSizeSmallLabel
    
    static let transitionDuration: CGFloat = 2
}

private extension HomeView {
    
    // MARK: Title
    
    var title: some View {
        Text("Shows")
            .style(.init(UIFont.merriweatherBold(size: titleFontSize)), color: .tvMazeWhite)
            .padding(.vertical, 8)
            .padding(.leading, titlePadding)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var titleFontSize: CGFloat {
        Self.titleSizeInterpolator.interpolate(value: -scrollViewOffset.y)
    }
    
    var titlePadding: CGFloat {
        Self.titlePaddingInterpolator.interpolate(value: -scrollViewOffset.y)
    }
    
    static let titleSizeInterpolator = SlopedStepRange(firstPoint: Self.scrollViewFirstThreshold, firstValue: .textSizeDisplay, secondPoint: Self.scrollViewSecondThreshold, secondValue: .textSizeLargeBody)
    
    static let titlePaddingInterpolator = SlopedStepRange(firstPoint: Self.scrollViewFirstThreshold, firstValue: 16, secondPoint: Self.scrollViewSecondThreshold, secondValue: (UIScreen.width - "Shows".getWidth(using: .boldBodyDefault)) / 2)
    
    // MARK: Refresh label
    
    var refreshLabel: some View {
        Text("Release to refresh")
            .style(.init(UIFont.merriweatherBold(size: refreshFontSize)), color: .tvMazeWhite)
            .opacity(refreshOpacity)
            .foregroundColor(.white)
            .padding(16 + 2 * 8 + titleFontSize)
    }
    
    var refreshOpacity: CGFloat {
        Self.refreshLabelOpacityInterpolator.interpolate(value: scrollViewOffset.y)
    }
    
    var refreshFontSize: CGFloat {
        Self.refreshLabelSizeInterpolator.interpolate(value: scrollViewOffset.y)
    }
    
    static let refreshLabelOpacityInterpolator = SlopedStepRange(firstPoint: Self.refreshFirstThreshold, firstValue: 0, secondPoint: Self.refreshSecondThreshold, secondValue: 1)
    
    static let refreshLabelSizeInterpolator = SlopedStepRange(firstPoint: Self.refreshFirstThreshold, firstValue: .textSizeCaption, secondPoint: Self.refreshSecondThreshold, secondValue: .textSizeBody)
    
    static let refreshFirstThreshold: CGFloat = .textSizeCaption + 2 * 8 + 16
    static let refreshSecondThreshold: CGFloat = .textSizeBody + 2 * 8 + 16
    
    // MARK: Recommended Shows
    
    var recommendedShows: some View {
        Group {
            if viewModel.isLoadingRecommendedShows {
                ProgressView()
                    .progressViewStyle(.circular)
                    .frame(maxWidth: .infinity)
                    .frame(height: RecommendedShowCard.height / 2)
            } else if viewModel.recommendedShows.isEmpty {
                Text(verbatim: "No recommended shows found.")
                    .style(.boldBodyDefault, color: .white, alignment: .center)
                    .frame(maxWidth: .infinity)
                    .frame(height: RecommendedShowCard.height / 2)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(viewModel.recommendedShows) { show in
                            RecommendedShowCard(model: show, isFavorite: favoritesService.binding(for: show.id))
                                .onTapGesture {
                                    viewModel.showPrimaryInfo = .init(from: show)
                                }
                                .readRect(into: rectBinding(id: show.id))
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .id(favoritesService.refreshToken ? 0 : 1)
            }
        }
    }
    
    func rectBinding(id: Int) -> Binding<CGRect> {
        .init(get: {
            recommendedRects[id] ?? .zero
        }, set: { value in
            recommendedRects[id] = value
        })
    }
    
    // MARK: Scheduled Shows
    
    var scheduledShows: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Scheduled")
                .style(.header2, color: .white)
                .padding(.leading, 16)
            
            if viewModel.isLoadingScheduledShows {
                ProgressView()
                    .progressViewStyle(.circular)
                    .frame(maxWidth: .infinity)
                    .frame(height: UIScreen.width / 2)
            } else if viewModel.scheduledShows.isEmpty {
                Text(verbatim: "No scheduled shows found.")
                    .style(.boldBodyDefault, color: .white, alignment: .center)
                    .frame(maxWidth: .infinity)
                    .frame(height: UIScreen.width / 2)
            } else {
                VStack(spacing: 16) {
                    ForEach(viewModel.scheduledShows) { show in
                        ScheduledShowCard(model: show)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, UIScreen.unsafeBottomPadding / 2)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    
    static var previews: some View {
        HomeView()
    }
}
