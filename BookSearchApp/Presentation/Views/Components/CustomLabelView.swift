//
//  CustomLabelView.swift
//  BookSearchApp
//
//  Created by 차상진 on 7/13/25.
//

import Foundation
import SwiftUI

struct CustimLabelView: View {
    
    let title: String
        let fontSize: CGFloat
        let fontColor: Color
        let limit: Int
        let iconName: String
        let iconColor: Color
        
        init(title: String, fontSize: CGFloat, fontColor: Color = .black, limit: Int = 1, iconName: String, iconColor: Color = .gray) {
            self.title = title
            self.fontSize = fontSize
            self.fontColor = fontColor
            self.limit = limit
            self.iconName = iconName
            self.iconColor = iconColor
        }
    
    var body: some View {
        Label {
            Text(title)
                .jalnanFont(size: fontSize, color: fontColor)
                .lineLimit(limit)
                .fixedSize(horizontal: false, vertical: true) // 텍스트가 줄바꿈되도록 허용
        } icon: {
            Image(systemName: iconName) // 사람 아이콘
                .foregroundColor(iconColor)
                .font(.system(size: fontSize))
        }
        .labelStyle(.titleAndIcon)
    }
}
