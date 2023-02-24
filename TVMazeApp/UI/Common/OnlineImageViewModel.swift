//
//  OnlineImageViewModel.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 15.02.2023..
//

import UIKit

final class OnlineImageViewModel: ObservableObject {
    
    @Published var image: UIImage?
    
    private let cacheService = CacheService.instance
    
    private var immediateCache: [String: UIImage] = [:]
    
    init(_ imageURL: String?) {
        guard let imageURL = imageURL else { return }

        if let image = immediateCache[imageURL] {
            self.image = image
            return
        }
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            if let cachedImage = self?.cacheService.getImage(for: imageURL) {
                DispatchQueue.main.async {
                    self?.image = cachedImage
                }
            } else {
                self?.fetchImage(at: imageURL)
            }
        }
    }
}

private extension OnlineImageViewModel {
    
    func fetchImage(at urlString: String, retriesLeft: Int = 5) {
        guard retriesLeft > 0,
              let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                print("Error downloading image from \(urlString): \(error)")
                print("\(String(describing: response))")
                self?.fetchImage(at: urlString, retriesLeft: retriesLeft - 1)
            }
            
            guard let self = self else { return }
            guard let data = data else {
                print("No data recived for image from: \(urlString)")
                return
            }
            
            guard let image = UIImage(data: data) else {
                print("Unable to create image from data recieved from: \(urlString)")
                return
                
            }
            
            self.cacheService.saveImage(for: urlString, image)
            DispatchQueue.main.async { [weak self] in
                self?.image = image
                self?.immediateCache[urlString] = image
            }
        }.resume()
    }
}
