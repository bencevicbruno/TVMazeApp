//
//  TruncatedTriangleInterpolator.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 24.02.2023..
//

import Foundation

struct TruncatedTriangleInterpolator: Interpolator {
    let firstLowThreshold: CGFloat
    let firstHighThreshold: CGFloat
    let secondHighThreshold: CGFloat
    let secondLowThreshold: CGFloat
    let minValue: CGFloat
    let maxValue: CGFloat
    
    func interpolate(_ value: CGFloat) -> CGFloat {
        guard value >= firstLowThreshold else { return minValue }
        guard value <= secondLowThreshold else { return minValue }
        
        if value >= firstHighThreshold && value <= secondHighThreshold {
            return maxValue
        }
        
        if value > firstLowThreshold && value < firstHighThreshold {
            return (maxValue - minValue) / (firstHighThreshold - firstLowThreshold) * (value - firstLowThreshold) + minValue
        }
        
        if value > secondHighThreshold && value < secondLowThreshold {
            return (maxValue - minValue) / (secondHighThreshold - secondLowThreshold) * (value - secondLowThreshold) + minValue
        }
            
        return value
    }
}
