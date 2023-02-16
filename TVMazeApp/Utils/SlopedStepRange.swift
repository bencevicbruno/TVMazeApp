//
//  SlopedStepRange.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 14.02.2023..
//

import Foundation

struct SlopedStepRange {
    
    let firstPoint: CGFloat
    let firstValue: CGFloat
    let secondPoint: CGFloat
    let secondValue: CGFloat
    
    init(firstPoint: CGFloat, firstValue: CGFloat, secondPoint: CGFloat, secondValue: CGFloat) {
        self.firstPoint = firstPoint
        self.firstValue = firstValue
        self.secondPoint = secondPoint
        self.secondValue = secondValue
    }
    
    func interpolate(value: CGFloat) -> CGFloat {
        guard value >= firstPoint else { return firstValue }
        guard value <= secondPoint else { return secondValue }
        
        return (secondValue - firstValue) / (secondPoint - firstPoint) * (value - firstPoint) + firstValue
    }
}
