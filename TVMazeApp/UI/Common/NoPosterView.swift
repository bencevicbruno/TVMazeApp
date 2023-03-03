//
//  NoPosterView.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 03.03.2023..
//

import SwiftUI

struct NoPosterView: View {
    
    var body: some View {
        Text("No poster\n:(")
            .style(.header2, color: .tvMazeWhite, alignment: .center)
            .lineSpacing(10)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.tvMazeDarkGray)
    }
}

struct NoPosterView_Previews: PreviewProvider {
    
    static var previews: some View {
        NoPosterView()
    }
}
