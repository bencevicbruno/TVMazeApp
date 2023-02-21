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
    
    func removingHTML(tags: [String] = ["b", "p", "i", "br", "br "]) -> String {
        return tags.reduce(into: self) { result, tag in
            result = result.replacing("<\(tag)>", with: "").replacing("</\(tag)>", with: "")
        }
    }
}
