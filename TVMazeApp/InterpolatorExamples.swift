//
//  InterpolatorExamples.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 03.03.2023..
//

import SwiftUI

struct InterpolatorExamples: View {
    
    @State private var sliderValue: CGFloat = 0
    @State private var circlePosition: CGPoint = .init(x: 0, y: 0)
    
    @State private var selectedInterpolator = 0
    
    var body: some View {
        VStack {
            Spacer()
            
            interpolatorSelection
                .padding(.horizontal, Self.sidePadding)
            
            Spacer()
            
            gridBackground
                .frame(size: Self.gridSize)
                .overlay {
                    Circle()
                        .offset(x: circlePosition.x - Self.circleSize / 2,
                                y: -circlePosition.y - Self.gridSize / 2 + Self.circleSize / 2)
                        .frame(size: 10)
                        .frame(size: Self.gridSize, alignment: .bottomLeading)
                }
            
            Spacer()
            
            Color.gray
                .overlay {
                    Text("🍕")
                        .scaleEffect(x: 5, y: 5)
                }
                .scaleEffect(
                    x: (Self.interpolators[selectedInterpolator].interpolate(sliderValue - Self.gridSize / 2)) / (Self.gridSize / 2),
                    y: (Self.interpolators[selectedInterpolator].interpolate(sliderValue - Self.gridSize / 2)) / (Self.gridSize / 2),
                    anchor: .center)
            
            Spacer()
            
            Slider(value: $sliderValue, in: 0...Self.gridSize)
                .tint(.blue)
                .padding(.horizontal, Self.sidePadding)
            
            Spacer()
        }
        .onChange(of: sliderValue) { _ in
            setCirclePosition()
        }
        .onChange(of: selectedInterpolator) { _ in
            setCirclePosition()
        }
        .onAppear {
            setCirclePosition()
        }
    }
    
    func setCirclePosition() {
        circlePosition.x = sliderValue
        circlePosition.y = Self.interpolators[selectedInterpolator].interpolate(sliderValue - Self.gridSize / 2)
    }
    
    static let sidePadding: CGFloat = 16
    static let gridSize = UIScreen.width - 2 * Self.sidePadding
    
    static let circleSize: CGFloat = 10
    
    private static let interpolators: [any Interpolator] = [
        SlopedStepInterpolator(firstPoint: -100, firstValue: -100, secondPoint: 100, secondValue: 100),
        SlopedStepInterpolator(firstPoint: -50, firstValue: 0, secondPoint: 100, secondValue: 100),
        TruncatedTriangleInterpolator(firstLowThreshold: -150, firstHighThreshold: -50, secondHighThreshold: 50, secondLowThreshold: 150, minValue: -100, maxValue: 100)
    ]
}

private extension InterpolatorExamples {
    
    static let linesCount = 11
    static let gridLineSpacing = Self.gridSize / CGFloat(Self.linesCount)
    static let gridColor = Color(uiColor: .lightGray)
    static let gridLineWidth: CGFloat = 1
    static let mainGridLineWidth: CGFloat = 4
    
    var interpolatorSelection: some View {
        HStack {
            ForEach(0..<Self.interpolators.count, id: \.self) {
                interpolatorButton($0)
            }
        }
    }
    
    func interpolatorButton(_ id: Int) -> some View {
        Button("#\(id + 1)") {
            self.selectedInterpolator = id
        }
        .frame(height: 40)
        .frame(maxWidth: .infinity).foregroundColor(selectedInterpolator == id ? .blue : .white)
        .background(selectedInterpolator == id ? .gray.opacity(0.25) : .blue)
        .cornerRadius(16)
    }
    
    var gridBackground: some View {
        ZStack {
            Color.white
            
            HStack(spacing: 0) {
                ForEach(1...Self.linesCount, id: \.self) { index in
                    Self.gridColor
                        .frame(width: Self.gridLineWidth)
                        .frame(width: Self.gridLineSpacing)
                }
            }
            
            VStack(spacing: 0) {
                ForEach(1...Self.linesCount, id: \.self) { index in
                    Self.gridColor
                        .frame(height: Self.gridLineWidth)
                        .frame(height: Self.gridLineSpacing)
                }
            }
            
            gridLabels
        }
    }
    
    var gridLabels: some View {
        ZStack {
            Color.red
                .frame(width: Self.mainGridLineWidth)
                .frame(size: Self.gridSize)
            
            Color.red
                .frame(height: Self.mainGridLineWidth)
                .frame(size: Self.gridSize)
        }
    }
}

struct InterpolatorExamples_Previews: PreviewProvider {
    
    static var previews: some View {
        InterpolatorExamples()
    }
}
