//
//  UIImage+.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 15.02.2023..
//

import AVFoundation
import UIKit

extension UIImage {
    
    func resizedForScreen() -> UIImage {
        return self.resized(to: .init(width: UIScreen.width / 2, height: UIScreen.width / 2))
    }
    
    func resized(to size: CGSize) -> UIImage {
        let maxSize = CGSize(width: 1000, height: 1000)

        let availableRect = AVFoundation.AVMakeRect(aspectRatio: self.size, insideRect: .init(origin: .zero, size: maxSize))
        let targetSize = availableRect.size

        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        let renderer = UIGraphicsImageRenderer(size: targetSize, format: format)

        let resized = renderer.image { (context) in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
        
        return resized
    }
}
