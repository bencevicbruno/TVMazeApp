//
//  String+.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 12.02.2023..
//

import UIKit

extension String {
    
    func getWidth(using font: UIFont) -> CGFloat {
        return (self as NSString).size(withAttributes: [.font: font]).width
    }
}
