//
//  TestPager.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 22.02.2023..
//

import SwiftUI

struct TruncatedTriangleInterpolator {
    let firstLowThreshold: CGFloat
    let firstHighThreshold: CGFloat
    let secondHighThreshold: CGFloat
    let secondLowThreshold: CGFloat
    let minValue: CGFloat
    let maxValue: CGFloat
    
    func interpolate(_ value: CGFloat) -> CGFloat {
        guard value >= firstLowThreshold else { return minValue }
        guard value <= secondLowThreshold else { return minValue }
        
        if value >= firstHighThreshold && value <= secondHighThreshold {
            return maxValue
        }
        
        if value > firstLowThreshold && value < firstHighThreshold {
            return (maxValue - minValue) / (firstHighThreshold - firstLowThreshold) * (value - firstLowThreshold) + minValue
        }
        
        if value > secondHighThreshold && value < secondLowThreshold {
            return (maxValue - minValue) / (secondHighThreshold - secondLowThreshold) * (value - secondLowThreshold) + minValue
        }
            
        return value
    }
}

struct TestCard: View {
    
    let sizeInterpolator = TruncatedTriangleInterpolator(firstLowThreshold: 16, firstHighThreshold: UIScreen.width / 2 - 2 * 16, secondHighThreshold: UIScreen.width / 2 + 2 * 16, secondLowThreshold: UIScreen.width - 16, minValue: UIScreen.width - 16 * 8, maxValue: UIScreen.width - 16 * 2)
    
    let title: String
    
    var body: some View {
        GeometryReader { proxy in
            Text(title)
                .foregroundColor(.white)
                .frame(size: sizeInterpolator.interpolate(proxy.frame(in: .global).midX), alignment: .center)
                .background(.cyan)
                .frame(width: proxy.size.width, height: proxy.size.height)
        }
        .frame(size: UIScreen.width - 16 * 2, alignment: .center)
        .background(.yellow.opacity(0.3))
    }
}

struct SnappableScrollView<T>: View where T: View {
    
    @State private var scrollViewOffset: CGPoint = .zero
    @State private var proxy: ScrollViewProxy?
    @State private var lastChangeTime: Date?
    
    let axes: Axis.Set
    let showsIndicator: Bool
    @Binding var offset: CGPoint
    let content: T
    let onSnap: (ScrollViewProxy) -> Void
    
    private let timer = Timer.publish(every: 0.25, on: .main, in: .common).autoconnect()
    
    init(axes: Axis.Set = .vertical,
         showsIndicator: Bool = true,
         offset: Binding<CGPoint> = .constant(.zero),
         @ViewBuilder content: () -> T,
         onSnap: @escaping (ScrollViewProxy) -> Void) {
        self.axes = axes
        self.showsIndicator = showsIndicator
        self._offset = offset
        self.content = content()
        self.onSnap = onSnap
    }
    
    var body: some View {
        OffsettableScrollView(axes: axes, showsIndicator: showsIndicator, offset: $offset) {
            ScrollViewReader { proxy in
                content
                    .onAppear {
                        self.proxy = proxy
                    }
            }
        }
        .onChange(of: offset) { newOffset in
            lastChangeTime = .now
        }
        .onReceive(timer) { _ in
            checkForSnap()
        }
    }
    
    func checkForSnap() {
        if let lastChangeTime,
           Date.now.timeIntervalSince(lastChangeTime) > 0.25,
           let proxy {
            onSnap(proxy)
            self.lastChangeTime = nil
        }
    }
}

struct TestPager: View {
    
    @State private var scrollViewOffset: CGPoint = .zero
    @State private var refreshToken = true
    
    var body: some View {
        SnappableScrollView(axes: .horizontal, showsIndicator: true, offset: $scrollViewOffset)
        {
            HStack(alignment: .center, spacing: 16) {
                ForEach(0...9, id: \.self) { index in
                    TestCard(title: "Hello #\(index)")
                        .id(index)
                }
            }
            .padding(.horizontal, 16)
        } onSnap: { proxy in
            withAnimation {
                proxy.scrollTo(scrollOffsetToIndex, anchor: .center)
            }
//            refreshToken.toggle()
//            print(scrollOffsetToIndex)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(refreshToken ? .blue : .red)
        .onChange(of: scrollViewOffset) {
            print($0)
        }
    }
    
    var scrollOffsetToIndex: Int {
        Int(round(Double(-scrollViewOffset.x / (UIScreen.width - 16 * 2 + 16))))
    }
}

struct TestPager_Previews: PreviewProvider {
    static var previews: some View {
        TestPager()
    }
}
