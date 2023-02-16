//
//  OnlineImage.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 15.02.2023..
//

import SwiftUI

struct OnlineImage<Content, Placeholder>: View where Content: View, Placeholder: View {
    
    private let contentBuilder: (Image) -> Content
    private let placeholderBuilder: () -> Placeholder
    
    @StateObject var viewModel: OnlineImageViewModel
    
    init(_ url: String, content: @escaping (Image) -> Content, placeholder: @escaping () -> Placeholder) {
        self.contentBuilder = content
        self.placeholderBuilder = placeholder
        
        self._viewModel = .init(wrappedValue: .init(url))
    }
    
    var body: some View {
        if let image = viewModel.image {
           contentBuilder(Image(uiImage: image))
        } else {
            placeholderBuilder()
        }
    }
}

struct OnlineImage_Previews: PreviewProvider {
    
    static var previews: some View {
        OnlineImage("https://geographical.co.uk/wp-content/uploads/panda1200-1.jpg") { image in
            image
                .resizable()
                .scaledToFit()
        } placeholder: {
            ProgressView()
                .progressViewStyle(.circular)
        }
    }
}
