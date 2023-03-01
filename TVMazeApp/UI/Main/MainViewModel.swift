//
//  MainViewModel.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 21.02.2023..
//

import SwiftUI

final class MainViewModel: ObservableObject {
    
    @Published var currentTab: MainTab = .home
    @Published var isTabBarVisible = true
    @Published var isTitleHidden = false
    @Published var isSwipeGestureDisabled = false
    @Published private(set) var toastMessage: String?
    
    private var toastQueue: [String] = []
    private var lastToastDate: Date?
    private var isChangingToast: Bool = false
    
    private var timer: Timer!
    
    private init() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self,
                  !self.isChangingToast else { return }
            
            let isToastVisible = self.toastMessage != nil
            let isToastExpired = Date().timeIntervalSince(self.lastToastDate ?? Date()) > 4
            
            if (isToastVisible && isToastExpired) || !isToastVisible {
                self.isChangingToast = true
                let newToast = self.toastQueue.first
                
                if newToast != nil {
                    self.toastQueue.remove(at: 0)
                }
                
                self.lastToastDate = newToast == nil ? nil : .now.addingTimeInterval(0.25)
                withAnimation(.linear(duration: 0.25)) {
                    self.toastMessage = nil
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    withAnimation(.linear(duration: 0.25)) {
                        self.toastMessage = newToast
                    }
                    self.isChangingToast = false
                }
            }
        }
    }
    
    static let instance = MainViewModel()
    
    var shouldDisableSwipgesture: Bool {
        isSwipeGestureDisabled || (!isTabBarVisible && isTitleHidden)
    }
    
    func showToast(_ message: String) {
        toastQueue.append(message)
    }
}
