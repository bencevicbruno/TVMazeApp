//
//  TVMazeApp.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 12.02.2023..
//

import SwiftUI

enum AppState {
    case splash
    case main
}

@main
struct TVMazeApp: App {
    
    @State private var appState: AppState = .splash
    
    var body: some Scene {
        WindowGroup {
            if appState == .splash {
                SplashScreenView($appState)
            } else {
                MainView()
                    .preferredColorScheme(.dark)
            }
        }
    }
}
