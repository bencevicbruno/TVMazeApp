//
//  SplashScreenView.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 27.02.2023..
//

import SwiftUI

struct SplashScreenView: View {
    
    @Binding var appState: AppState
    
    init(_ appState: Binding<AppState>) {
        self._appState = appState
    }
    
    @State private var didAppear = false
    
    var body: some View {
        VStack {
            Spacer()
            
            Spacer()
            
            Image("icon_tv_maze_app")
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .frame(size: UIScreen.width / 2)
                .background(
                    Circle()
                        .fill(Color.tvMazeWhite)
                        .blur(radius: 64)
                )
            
            Spacer()
            
            Text("TV Maze App")
                .style(.display, color: .white, alignment: .center)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.tvMazeDarkGray)
        .edgesIgnoringSafeArea(.all)
        .overlay {
            starsOverlay
        }
        .onAppear {
            didAppear = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                appState = .main
            }
        }
    }
}

private extension SplashScreenView {
    
    var starsOverlay: some View {
        ZStack {
            star(32)
                .offset(x: UIScreen.width / 4 + 16, y: 16)
            
            star(44)
                .offset(x: -UIScreen.width / 4 - 20, y: -100)
            
            star(20)
                .offset(x: 10, y: 0)
            
            star(48)
                .offset(x: 24, y: -UIScreen.height / 4)
            
            star(36)
                .offset(x: -40, y: UIScreen.height / 6)
        }
    }
    
    func star(_ size: CGFloat) -> some View {
        Image("icon_star_filled")
            .resizable()
            .renderingMode(.template)
            .scaledToFit()
            .frame(size: size)
            .foregroundColor(.tvMazeYellow)
            .rotationEffect(.degrees(didAppear ? size * 10 : 0), anchor: .center)
            .animation(.easeOut(duration: 3.0), value: didAppear)
            .scaleEffect(x: didAppear ? 1 : 0, y: didAppear ? 1 : 0, anchor: .center)
            .animation(.easeOut(duration: 1), value: didAppear)
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView(.constant(.splash))
    }
}
