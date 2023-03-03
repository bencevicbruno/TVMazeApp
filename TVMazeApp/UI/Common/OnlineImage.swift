//
//  OnlineImage.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 15.02.2023..
//

import SwiftUI

struct OnlineImage<Content, Placeholder, Error>: View where Content: View, Placeholder: View, Error: View {
    
    private let contentBuilder: (Image) -> Content
    private let placeholderBuilder: Placeholder
    private let errorBuilder: Error
    
    @StateObject var viewModel: OnlineImageViewModel
    
    init(_ url: String?, content: @escaping (Image) -> Content, placeholder: () -> Placeholder, error: () -> Error) {
        self.contentBuilder = content
        self.placeholderBuilder = placeholder()
        self.errorBuilder = error()
        
        self._viewModel = .init(wrappedValue: .init(url))
    }
    
    var body: some View {
        switch viewModel.state {
        case .loading:
            placeholderBuilder
        case let .loaded(uiImage):
            contentBuilder(Image(uiImage: uiImage))
        case .error:
            errorBuilder
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
        } error: {
            Text("Error")
        }
    }
}
