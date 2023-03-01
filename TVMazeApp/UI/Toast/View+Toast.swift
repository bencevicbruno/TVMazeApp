//
//  View+Toast.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 28.02.2023..
//

import SwiftUI

extension View {
    
    func presentToast(_ message: String?) -> some View {
        self.overlay {
            ToastOverlay(message: message)
        }
    }
}
