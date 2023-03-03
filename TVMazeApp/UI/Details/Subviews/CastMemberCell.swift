//
//  CastMemberCell.swift
//  TVMazeApp
//
//  Created by Bruno Bencevic on 17.02.2023..
//

import SwiftUI

struct CastMemberCell: View {
    
    private let model: CastMemberModel
    
    init(model: CastMemberModel) {
        self.model = model
    }
    
    var body: some View {
        HStack(spacing: 16) {
            OnlineImage(model.avatarURL) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(.white)
            } error: {
                NoPosterView()
            }
            .frame(size: 80)
            .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(verbatim: model.name)
                    .style(.boldBodyDefault, color: .tvMazeWhite)
                    .lineLimit(2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(verbatim: model.roleName)
                    .style(.smallCaption, color: .tvMazeWhite)
                    .lineLimit(2)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(16)
        .background(Color.tvMazeGray)
    }
}

struct CastMemberCell_Previews: PreviewProvider {
    
    static var previews: some View {
        CastMemberCell(model: .sample())
    }
}
