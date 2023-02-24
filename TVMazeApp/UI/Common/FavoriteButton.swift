//
//  FavoriteButton.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 13.02.2023..
//

import SwiftUI

struct FavoriteButton: View {
    
    @Binding var isFavorite: Bool
    
    private let imageSize: CGFloat
    private let iconSize: CGFloat
    
    @State private var scale: CGFloat = 1.0
    
    init(_ isFavorite: Binding<Bool>, imageSize: CGFloat = Self.defaultImageSize, iconSize: CGFloat = Self.defaultIconSize) {
        self._isFavorite = isFavorite
        self.imageSize = imageSize
        self.iconSize = iconSize
    }
    
    var body: some View {
        Image("icon_heart_filled")
            .resizable()
            .renderingMode(.template)
            .scaledToFit()
            .frameAsIcon(imageSize: imageSize, iconSize: iconSize - 4)
            .foregroundColor(foregroundColor)
            .background(Color.tvMazeBlack)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .padding(2)
            .background(foregroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .contentShape(Rectangle())
            .scaleEffect(x: scale, y: scale, anchor: .center)
            .onTapGesture {
                isFavorite.toggle()
            }
            .onChange(of: isFavorite) { _ in
                withAnimation(.spring(response: 0.5, dampingFraction: 0.3, blendDuration: 0.1)) {
                    scale = 1.5
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.3, blendDuration: 0.1)) {
                        scale = 1
                    }
                }
            }
    }
    
    static let defaultImageSize: CGFloat = 24
    static let defaultIconSize: CGFloat = 40
}

private extension FavoriteButton {
    
    var foregroundColor: Color {
        isFavorite ? .tvMazeYellow : .tvMazeLightGray
    }
}

struct FavoriteButton_Previews: PreviewProvider {
    
    static var previews: some View {
        HStack {
            FavoriteButton(.constant(true))
            
            FavoriteButton(.constant(false))
        }
    }
}
