//
//  ToastOverlay.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 28.02.2023..
//

import SwiftUI

struct ToastOverlay: View {
    
    let message: String?
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            if let message {
                Text(message)
                    .style(.boldSmallCaption, color: .white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(16)
                    .background(Color.tvMazeDarkGray)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .background(Color.black.blur(radius: 16))
                    .padding(.horizontal, 16)
                    .padding(.bottom, max(UIScreen.unsafeBottomPadding, 16) + 16)
                    .transition(.move(edge: .bottom))
            }
        }
    }
}

struct ToastOverlay_Previews: PreviewProvider {
    
    static var previews: some View {
        ToastOverlay(message: "Lorem ipsum, tralala, haha haha hahahah hahah iks de lololo")
    }
}
