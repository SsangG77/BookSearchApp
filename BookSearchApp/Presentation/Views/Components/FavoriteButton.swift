//
//  FavoriteButton.swift
//  BookSearchApp
//
//  Created by 차상진 on 7/13/25.
//

import Foundation
import SwiftUI

struct FavoriteButton: View {
    
    var isFavorite: Bool // 이미지 표시를 위한 즐겨찾기 유무 변수
    var action: () -> Void // 버튼 클릭시 실행할 클로저
    
    var body: some View {
        // 즐겨찾기 아이콘
        Button(action: {
            // 햅틱 피드백 추가
            let impactMed = UIImpactFeedbackGenerator(style: .medium)
            impactMed.impactOccurred()
            action()
        }) {
            // 즐겨찾기 유무에 따라 하트 이미지 다르게 표시
            Image(systemName: isFavorite ? "heart.fill" : "heart")
                .font(.title)
                .foregroundColor(Color.mainColor)
        }
        .buttonStyle(PlainButtonStyle())
        .contentShape(Rectangle()) // 탭 영역을 명확히 정의
    }
}
