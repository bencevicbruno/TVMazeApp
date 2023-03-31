//
//  LazyView.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 29.03.2023..
//

import SwiftUI

struct LazyView<Content: View>: View {
    private let content: () -> Content
    
    init(_ content: @autoclosure @escaping () -> Content) {
        self.content = content
    }
    
    var body: Content {
        content()
    }
}
