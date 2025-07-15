//
//  BookItemLoadingSkeleton.swift
//  BookSearchApp
//
//  Created by 차상진 on 7/15/25.
//

import SwiftUI

//MARK: - 도서 아이템 로딩 스켈레돈
/// 로딩 스켈레톤으로 사용자 경험 향상
struct BookItemLoadingSkeleton: View {
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            // 도서 표지 이미지 스켈레톤
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 110, height: 160)
                .clipped()

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    // "도서" 텍스트 스켈레톤
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 30, height: 15)

                    Spacer()

                    // 즐겨찾기 아이콘 스켈레톤
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 32, height: 32)
                }

                // 제목 스켈레톤 (두 줄)
                VStack(alignment: .leading, spacing: 5) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 32)
                }

                // 저자 스켈레톤
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 100, height: 15)

                HStack {
                    // 출판사 스켈레톤
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 80, height: 15)

                    Spacer()

                    // 도서 판매 상태 스켈레톤
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 60, height: 20)
                }
                HStack {
                    Spacer()
                    // 가격 스켈레톤
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 130, height: 26)
                }
            } // VStack
            .padding(7)
        } // HStack
        .padding(7)
        .frame(height: 180)
        .background(Color.white)
        .cornerRadius(12)
        .listRowBackground(Color.clear)
        .redacted(reason: .placeholder)
    }
}

#Preview {
    BookItemLoadingSkeleton()
}
