//
//  UIFont+.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 12.02.2023..
//

import UIKit

extension UIFont {
    
    /// bold 32
    static let display = UIFont.merriweatherBlack(size: .textSizeDisplay)
    
    /// bold 24
    static let header1 = UIFont.merriweatherBlack(size: .textSizeHeader1)
    /// bold 20
    static let header2 =  UIFont.merriweatherBlack(size: .textSizeHeader2)
    
    /// light 24
    static let lightBodyLarge = UIFont.merriweatherLight(size: .textSizeLargeBody)
    /// regular 24
    static let bodyLargeDefault = UIFont.merriweatherRegular(size: .textSizeLargeBody)
    
    /// regular 18
    static let bodyDefault = UIFont.merriweatherRegular(size: .textSizeBody)
    /// bold 18
    static let boldBodyDefault = UIFont.merriweatherBold(size: .textSizeBody)
    /// light 18
    static let lightBodyDefault = UIFont.merriweatherLight(size: .textSizeBody)
    
    /// regular 16
    static let captionDefault = UIFont.merriweatherRegular(size: .textSizeCaption)
    /// bold 16
    static let boldCaptionDefualt = UIFont.merriweatherBold(size: .textSizeCaption)
    /// light 16
    static let lightCaptionDefault = UIFont.merriweatherLight(size: .textSizeCaption)

    /// regular 14
    static let smallCaption = UIFont.merriweatherRegular(size: .textSizeSmallCaption)
    /// bold 14
    static let boldSmallCaption = UIFont.merriweatherBold(size: .textSizeSmallCaption)
    
    /// regular 12
    static let label = UIFont.merriweatherRegular(size: .textSizeLabel)
    /// bold 12
    static let boldLabel = UIFont.merriweatherBold(size: .textSizeLabel)
    
    static func printFonts() {
        for familyName in UIFont.familyNames {
            print("[\(familyName)]:", terminator: " ")
            print(UIFont.fontNames(forFamilyName: familyName).joined(separator: ", "))
        }
    }
}

extension UIFont {
    
    static func merriweatherBlack(size: CGFloat) -> UIFont {
        return UIFont(name: "Merriweather-Black", size: size)!
    }
    
    static func merriweatherBlackItalic(size: CGFloat) -> UIFont {
        return UIFont(name: "Merriweather-BlackItalic", size: size)!
    }
    
    static func merriweatherBold(size: CGFloat) -> UIFont {
        return UIFont(name: "Merriweather-Bold", size: size)!
    }
    
    static func merriweatherBoldItalic(size: CGFloat) -> UIFont {
        return UIFont(name: "Merriweather-BoldItalic", size: size)!
    }
    
    static func merriweatherItalic(size: CGFloat) -> UIFont {
        return UIFont(name: "Merriweather-Italic", size: size)!
    }
    
    static func merriweatherLight(size: CGFloat) -> UIFont {
        return UIFont(name: "Merriweather-Light", size: size)!
    }
    
    static func merriweatherLightItalic(size: CGFloat) -> UIFont {
        return UIFont(name: "Merriweather-LightItalic", size: size)!
    }
    
    static func merriweatherRegular(size: CGFloat) -> UIFont {
        return UIFont(name: "Merriweather-Regular", size: size)!
    }
}
