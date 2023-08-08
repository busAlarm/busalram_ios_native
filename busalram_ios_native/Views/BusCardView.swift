//
//  BusCardView.swift
//  busalram_ios_native
//
//  Created by 한현민 on 2023/08/08.
//

import SwiftUI

struct BusCardView: View {
    var cardColor: Color
    var innerText: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(cardColor)
                .opacity(0.5)
            
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .stroke(lineWidth: 2.0)
            
            Text(innerText)
                .fontWeight(.heavy)
                .padding(8) // 내부 패딩
        }
        .frame(width: 80, height: 30)
        .padding(.leading, 2)
        .padding(.trailing, 4) // 외부 패딩
        .padding(.vertical, 6)
    }
}
