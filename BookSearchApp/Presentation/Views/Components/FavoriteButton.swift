//
//  FavoriteButton.swift
//  BookSearchApp
//
//  Created by 차상진 on 7/13/25.
//

import Foundation
import SwiftUI

struct FavoriteButton: View {
    
    var isFavorite: Bool
    var action: () -> Void
    
    var body: some View {
        // 즐겨찾기 아이콘
        Button(action: action) {
            // 즐겨찾기 버튼 이미지
            Image(systemName: isFavorite ? "heart.fill" : "heart")
                .font(.title) // 폰트 크기 조절
                .foregroundColor(Color.mainColor)
        } /// - Button, Label
        .buttonStyle(PlainButtonStyle()) // 버튼 스타일 명시
        .contentShape(Rectangle()) // 탭 영역을 명확히 정의
    }
}
