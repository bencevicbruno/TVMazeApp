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
    
    init(title: String, isTitleHidden: Bool, _ content: @escaping () -> Content, onRefresh: (() -> Void)? = nil) {
        self.title = title
        self.isTitleHidden = isTitleHidden
        self.content = content
        self.onRefresh = onRefresh
        
        self.titlePaddingInterpolator = SlopedStepRange(firstPoint: TVMazeScrollViewUtils.titleFirstThreshold, firstValue: 16, secondPoint: TVMazeScrollViewUtils.titleSecondThreshold, secondValue: (UIScreen.width - "Shows".getWidth(using: .boldBodyDefault)) / 2)
    }
    
    @State private var scrollViewOffset: CGPoint = .zero
    @State private var canTriggerRefresh = false
    
    var body: some View {
        ZStack(alignment: .top) {
            OffsettableScrollView(axes: .vertical, showsIndicator: false, offset: $scrollViewOffset) {
                content()
            }
            .padding(.top, isTitleHidden ? 0 : 2 * 8 + titleFontSize)
            
            VStack(spacing: 0) {
                titleLabel
                    .offset(y: isTitleHidden ? -(.textSizeDisplay + 2 * 8 + UIScreen.unsafeTopPadding) : 0)
                    .animation(.easeOut(duration: 2), value: isTitleHidden)
                
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.tvMazeBlack)
        .overlay(alignment: .top) {
            refreshLabel
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
        titleSizeInterpolator.interpolate(value: -scrollViewOffset.y)
    }
    
    var titlePadding: CGFloat {
        titlePaddingInterpolator.interpolate(value: -scrollViewOffset.y)
    }
    
    let titleSizeInterpolator = SlopedStepRange(firstPoint: TVMazeScrollViewUtils.titleFirstThreshold, firstValue: .textSizeDisplay, secondPoint: TVMazeScrollViewUtils.titleSecondThreshold, secondValue: .textSizeLargeBody)
    
    let titlePaddingInterpolator: SlopedStepRange
    
    // MARK: - Refresh
    
    var refreshLabel: some View {
        Text("Release to refresh")
            .style(.init(UIFont.merriweatherBold(size: refreshFontSize)), color: .tvMazeWhite)
            .opacity(refreshOpacity)
            .foregroundColor(.white)
            .padding(16 + 2 * 8 + titleFontSize)
    }
    
    var refreshOpacity: CGFloat {
        refreshLabelOpacityInterpolator.interpolate(value: scrollViewOffset.y)
    }
    
    var refreshFontSize: CGFloat {
        refreshLabelSizeInterpolator.interpolate(value: scrollViewOffset.y)
    }
    
    let refreshLabelOpacityInterpolator = SlopedStepRange(
        firstPoint: TVMazeScrollViewUtils.refreshFirstThreshold,
        firstValue: 0,
        secondPoint: TVMazeScrollViewUtils.refreshSecondThreshold,
        secondValue: 1)
    
    let refreshLabelSizeInterpolator = SlopedStepRange(
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
