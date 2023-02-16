//
//  UIScreen+.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 12.02.2023..
//

import UIKit

extension UIScreen {
    
    static let width = UIScreen.main.bounds.width
    
    static let height = UIScreen.main.bounds.height
    
    static var isSmall: Bool {
        Self.width <= 320
    }
    
    static let unsafeTopPadding: CGFloat = UIApplication.shared.windows.first?.safeAreaInsets.top ?? 60
    
    static let unsafeBottomPadding: CGFloat = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 60
}
