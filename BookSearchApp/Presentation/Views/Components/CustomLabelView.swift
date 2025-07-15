//
//  CustomLabelView.swift
//  BookSearchApp
//
//  Created by 차상진 on 7/13/25.
//

import Foundation
import SwiftUI

//MARK: - 아이콘 + 라벨을 관리하는 뷰
struct CustimLabelView: View {
    
    let title: String       // 라벨 타이틀
    let fontSize: CGFloat   // 폰트 크기 (아이콘, 라벨 동시 적용)
    let fontColor: Color    // 폰트 색상
    let limit: Int          // 허용 줄바꿈 수
    let iconName: String    // 아이콘 이미지 이름
    let iconColor: Color    // 아이콘 색상
    
    init(
        title: String,
        fontSize: CGFloat,
        fontColor: Color = .black,
        limit: Int = 1,
        iconName: String,
        iconColor: Color = .gray
    ) {
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
                .jalnanFont(size: fontSize, color: fontColor) // 여기 어때 서체 자동 적용
                .lineLimit(limit)
                .fixedSize(horizontal: false, vertical: true) // 텍스트가 줄바꿈되도록 허용
        } icon: {
            Image(systemName: iconName)
                .foregroundColor(iconColor)
                .font(.system(size: fontSize))
        }
        .labelStyle(.titleAndIcon)
    }
}
