//
//  Binding.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 20.02.2023..
//

import SwiftUI

extension Binding {
    
    var readOnly: Self {
        .init(get: { self.wrappedValue }, set: { _ in })
    }
}
