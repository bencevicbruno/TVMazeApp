//
//  MainTabBar.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 17.02.2023..
//

import SwiftUI

struct MainTabBar: View {
    
    @Binding var currentTab: MainTab
    
    @State private var rect: CGRect = .zero
    
    init(_ currentTab: Binding<MainTab>) {
        self._currentTab = currentTab
    }
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(MainTab.allCases) { tab in
                Image(tab.iconName(selected: currentTab == tab))
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .frameAsIcon(imageSize: Self.iconSize, iconSize: Self.iconSize)
                    .padding(.top, Self.iconTopPadding)
                    .padding(.bottom, Self.iconBottomPadding)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(currentTab == tab ? .tvMazeYellow : .tvMazeLightGray)
                    .onTapGesture {
                        currentTab = tab
                    }
            }
        }
        .background(Color.tvMazeDarkGray)
        .background(Color.black.blur(radius: Self.shadowSize))
        .readRect(into: $rect)
    }
    
    static let iconSize: CGFloat = 32
    static let iconTopPadding: CGFloat = 12
    static let iconBottomPadding: CGFloat = max(iconTopPadding, UIScreen.unsafeBottomPadding)
    static let height: CGFloat = Self.iconSize + Self.iconTopPadding + Self.iconBottomPadding
    
    static let shadowSize: CGFloat = 16
}

struct MainTabBar_Previews: PreviewProvider {
    
    static var previews: some View {
        MainTabBar(.constant(MainTab.allCases.randomElement()!))
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            .edgesIgnoringSafeArea(.all)
    }
}
