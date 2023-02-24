//
//  SnappableScrollView.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 22.02.2023..
//

import SwiftUI

enum SnappableScrollViewUtils {
    
    static let timerInterval = 0.2
}

struct SnappableScrollView<T>: View where T: View {
    
    @State private var proxy: ScrollViewProxy?
    @State private var lastChangeTime: Date?
    @State private var shouldCheckForSnapping = true
    
    let axes: Axis.Set
    let showsIndicator: Bool
    @Binding var offset: CGPoint
    let content: T
    let onSnap: (ScrollViewProxy) -> Void
    
    private let timer = Timer.publish(every: SnappableScrollViewUtils.timerInterval, on: .main, in: .common).autoconnect()
    
    init(axes: Axis.Set = .vertical,
         showsIndicator: Bool = true,
         offset: Binding<CGPoint>,
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
        guard shouldCheckForSnapping else { return }
        
        if let lastChangeTime,
           Date.now.timeIntervalSince(lastChangeTime) > SnappableScrollViewUtils.timerInterval,
           let proxy {
            self.shouldCheckForSnapping = false
            withAnimation(.easeOut(duration: SnappableScrollViewUtils.timerInterval)) {
                onSnap(proxy)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + SnappableScrollViewUtils.timerInterval) {
                self.shouldCheckForSnapping = true
            }
            self.lastChangeTime = nil
        }
    }
}
