//
//  PreviewDevice.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 13.02.2023..
//

import SwiftUI

enum PreviewDevice: String, CaseIterable, Identifiable {
    case iPhone14 = "iPhone 14"
    case iPhone14ProMax = "iPhone 14 Pro Max"
    case iPhone13Mini = "iPhone 13 Mini"
    case iPhoneXR = "iPhone XR"
    case iPhoneSE1stGeneration = "iPhone SE (1st generation)"
    case iPhoneSE2ndGeneration = "iPhone SE (2nd generation)"
    case iPhone8 = "iPhone 8"
    
    var id: Self {
        self
    }
}

extension View {
    
    func previewed(for device: PreviewDevice) -> some View {
        self.previewDisplayName(device.rawValue)
            .previewDevice(.init(.init(rawValue: device.rawValue)))
    }
}
