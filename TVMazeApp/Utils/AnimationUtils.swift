//
//  AnimationUtils.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 21.02.2023..
//

import SwiftUI

enum AnimationUtils {
    
    static let toggleBarsDuration = 0.25
    static let toggleBarsAnimation = Animation.linear(duration: Self.toggleBarsDuration)
    
    static let toggleDetailsDuration = 0.4
    static let showDetailsAnimation = Animation.easeOut(duration: Self.toggleDetailsDuration)
    static let hideDetailsAnimation = Animation.easeIn(duration: Self.toggleDetailsDuration)
    
}
