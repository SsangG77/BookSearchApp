//
//  CustomSearchBarView.swift
//  BookSearchApp
//
//  Created by 차상진 on 7/11/25.
//

import SwiftUI

struct CustomSearchBarView: View {
    @Binding var searchText: String
    let onSearch: (String) -> Void
    @FocusState private var isTextFieldFocused: Bool // 다시 @FocusState로 변경

    var body: some View {
        HStack {
            
            TextField("검색어를 입력하세요", text: $searchText)
                .padding(8)
                .background(Color.white.opacity(0.4))
                .cornerRadius(12)
                .foregroundColor(.white)
                .accentColor(.white) // 커서 색상
                .focused($isTextFieldFocused) // 포커스 상태 연결
                .onSubmit(of: .text) { // 키보드 리턴 키로 검색 실행
                    onSearch(searchText)
                }
            
            Button("취소") {
                searchText = ""
                isTextFieldFocused = false // 키보드 내리기
                onSearch("") // 검색어 초기화 후 빈 검색어로 다시 로드
            }
            .foregroundColor(.white)
            .opacity(isTextFieldFocused || !searchText.isEmpty ? 1 : 0) // 가시성 제어
            .frame(width: isTextFieldFocused || !searchText.isEmpty ? nil : 0) // 너비 제어
            .clipped() // 너비가 0일 때 내용 잘림 방지

        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color.mainColor)
        .frame(height: 50) // 명시적인 높이 지정
        .animation(.easeInOut, value: isTextFieldFocused || !searchText.isEmpty) // HStack 전체에 애니메이션 적용
    }
}

#Preview {
    CustomSearchBarView(searchText: .constant("Swift"), onSearch: { _ in })
}

