//
//  TVMazeScrollView.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 20.02.2023..
//

import SwiftUI

enum TVMazeScrollViewUtils {
    static let refreshThreshold: CGFloat = 100
    
    static let titleFirstThreshold: CGFloat = UIScreen.width
    static let titleSecondThreshold: CGFloat = UIScreen.width * 1.2
    
    static let refreshFirstThreshold: CGFloat = .textSizeCaption + 2 * 8 + 16
    static let refreshSecondThreshold: CGFloat = .textSizeBody + 2 * 8 + 16
}

struct TVMazeScrollView<Content>: View where Content: View {
    
    let title: String
    let isTitleHidden: Bool
    let content: () -> Content
    let onRefresh: (() -> Void)?
    
    init(title: String, isTitleHidden: Bool, firstThreshold: CGFloat = TVMazeScrollViewUtils.titleFirstThreshold, secondThreshold: CGFloat = TVMazeScrollViewUtils.titleSecondThreshold, _ content: @escaping () -> Content, onRefresh: (() -> Void)? = nil) {
        self.title = title
        self.isTitleHidden = isTitleHidden
        self.content = content
        self.onRefresh = onRefresh
        
        self.titleSizeInterpolator = SlopedStepInterpolator(firstPoint: firstThreshold, firstValue: .textSizeDisplay, secondPoint: secondThreshold, secondValue: .textSizeLargeBody)
        self.titlePaddingInterpolator = SlopedStepInterpolator(firstPoint: firstThreshold, firstValue: 16, secondPoint: secondThreshold, secondValue: (UIScreen.width - title.getWidth(using: .boldBodyDefault)) / 2)
    }
    
    @State private var scrollViewOffset: CGPoint = .zero
    @State private var canTriggerRefresh = false
    @State private var titleSize: CGSize = .zero
    
    var body: some View {
        ZStack(alignment: .top) {
            OffsettableScrollView(axes: .vertical, showsIndicator: false, offset: $scrollViewOffset) {
                content()
                    .padding(.top, 2 * 8 + titleFontSize + UIScreen.unsafeTopPadding)
            }
            
            VStack(spacing: 0) {
                titleLabel
                    .padding(.top, UIScreen.unsafeTopPadding)
                    .background(Color.tvMazeBlack)
                    .readSize(into: $titleSize)
                    .offset(y: isTitleHidden ? -(titleSize.height) : 0)
                
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.tvMazeBlack)
        .overlay(alignment: .top) {
            refreshLabel
                .padding(.top, titleFontSize + 2 * 8)
        }
        .onChange(of: scrollViewOffset) { newOffset in
            if newOffset.y > TVMazeScrollViewUtils.refreshThreshold {
                canTriggerRefresh = true
            }
            
            if newOffset.y <= 10 && canTriggerRefresh {
                canTriggerRefresh = false
                onRefresh?()
            }
        }
    }
    
    // MARK: - Title
    
    var titleLabel: some View {
        Text("Shows")
            .style(.init(UIFont.merriweatherBold(size: titleFontSize)), color: .tvMazeWhite)
            .padding(.vertical, 8)
            .padding(.leading, titlePadding)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var titleFontSize: CGFloat {
        titleSizeInterpolator.interpolate(-scrollViewOffset.y)
    }
    
    var titlePadding: CGFloat {
        titlePaddingInterpolator.interpolate(-scrollViewOffset.y)
    }
    
    let titleSizeInterpolator: SlopedStepInterpolator
    
    let titlePaddingInterpolator: SlopedStepInterpolator
    
    // MARK: - Refresh
    
    var refreshLabel: some View {
        Text("Release to refresh")
            .style(.init(UIFont.merriweatherBold(size: refreshFontSize)), color: .tvMazeWhite)
            .opacity(refreshOpacity)
            .foregroundColor(.white)
            .padding(16 + 2 * 8 + titleFontSize)
    }
    
    var refreshOpacity: CGFloat {
        refreshLabelOpacityInterpolator.interpolate(scrollViewOffset.y)
    }
    
    var refreshFontSize: CGFloat {
        refreshLabelSizeInterpolator.interpolate(scrollViewOffset.y)
    }
    
    let refreshLabelOpacityInterpolator = SlopedStepInterpolator(
        firstPoint: TVMazeScrollViewUtils.refreshFirstThreshold,
        firstValue: 0,
        secondPoint: TVMazeScrollViewUtils.refreshSecondThreshold,
        secondValue: 1)
    
    let refreshLabelSizeInterpolator = SlopedStepInterpolator(
        firstPoint: TVMazeScrollViewUtils.refreshFirstThreshold,
        firstValue: .textSizeCaption,
        secondPoint: TVMazeScrollViewUtils.refreshSecondThreshold,
        secondValue: .textSizeBody)
}

struct TVMazeScrollView_Previews: PreviewProvider {
    
    static var previews: some View {
        TVMazeScrollView(title: "Example", isTitleHidden: false) {
            VStack {
                ForEach(1...30, id: \.self) { number in
                    Text("Test \(number)")
                        .style(.display, color: .white)
                        .frame(height: RecommendedShowCard.height)
                        .frame(maxWidth: .infinity)
                        .background(.gray)
                        .padding()
                }
            }
        }
    }
}
