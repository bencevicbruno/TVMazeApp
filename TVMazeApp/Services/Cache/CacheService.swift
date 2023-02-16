//
//  CacheService.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 15.02.2023..
//

import UIKit

final class CacheService {
    
    let fileManager = FileManager.default
    
    static let instance = CacheService()
    
    init() {}
    
    func getImage(for id: String) -> UIImage? {
        let urlSafeID = getSafeURL(id)
        
        guard let imageData = try? Data(contentsOf: fileManager.getURLFor(filename: urlSafeID)) else {
            print("Unable to read image data for \(urlSafeID).")
            return nil
        }
        
        guard let image = UIImage(data: imageData) else {
            print("Unable to create image from data for \(urlSafeID).")
            return nil
        }
        
        return image
    }
    
    func saveImage(for id: String, _ image: UIImage) {
        let urlSafeID = getSafeURL(id)
        
        guard let imageData = image.pngData() else {
            print("Unable to encode image to jpeg data for \(urlSafeID).")
            return
        }
        
        do {
            try imageData.write(to: fileManager.getURLFor(filename: urlSafeID))
        } catch {
            print("Unable to save image to disk for \(urlSafeID): \(error)")
        }
    }
    
    func getSafeURL(_ string: String) -> String {
        return string.replacing(":", with: "").replacing("/", with: "")
    }
}
