//
//  OnlineImageViewModel.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 15.02.2023..
//

import UIKit

final class OnlineImageViewModel: ObservableObject {
    
    @Published var state: ContentState
    
    private let cacheService = CacheService.instance
    
    private static var immediateCache: [String: UIImage] = [:]
    
    init(_ imageURL: String?) {
        self.state = .loading
        
        guard let imageURL = imageURL else {
            state = .error
            return
        }

        if let image = Self.immediateCache[imageURL] {
            self.state = .loaded(image)
            return
        }
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            if let cachedImage = self?.cacheService.getImage(for: imageURL) {
                DispatchQueue.main.async {
                    self?.state = .loaded(cachedImage)
                }
            } else {
                self?.fetchImage(at: imageURL)
            }
        }
    }
    
    init(cached imageURL: String?) {
        guard let imageURL = imageURL else {
            state = .error
            return
        }
        
        if let image = Self.immediateCache[imageURL] {
            self.state = .loaded(image)
            return
        }
        
        if let cachedImage = self.cacheService.getImage(for: imageURL) {
            self.state = .loaded(cachedImage)
        } else {
            self.state = .error
        }
    }
    
    enum ContentState {
        case loading
        case loaded(UIImage)
        case error
    }
}

private extension OnlineImageViewModel {
    
    func fetchImage(at urlString: String, retriesLeft: Int = 5) {
        guard retriesLeft > 0,
              let url = URL(string: urlString) else {
            self.state = .error
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                print("Error downloading image from \(urlString): \(error)")
                print("\(String(describing: response))")
                self?.fetchImage(at: urlString, retriesLeft: retriesLeft - 1)
            }
            
            guard let self = self else { return }
            guard let data = data else {
                print("No data recived for image from: \(urlString)")
                self.state = .error
                return
            }
            
            guard let image = UIImage(data: data) else {
                print("Unable to create image from data recieved from: \(urlString)")
                self.state = .error
                return
                
            }
            
            self.cacheService.saveImage(for: urlString, image)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                self?.state = .loaded(image)
                Self.immediateCache[urlString] = image
            }
        }.resume()
    }
}
