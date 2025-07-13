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
    @FocusState private var isTextFieldFocused: Bool

    var body: some View {
        HStack {
            TextField("검색어를 입력하세요", text: $searchText)
                .padding(8)
                .background(Color.white.opacity(0.4))
                .cornerRadius(12)
                .foregroundColor(.white) // searchText 색상
                .accentColor(.white) // 커서 색상
                .focused($isTextFieldFocused)
                .onSubmit(of: .text) {
                    onSearch(searchText)
                }
            
            Button("취소") {
                searchText = ""
                isTextFieldFocused = false // 키보드 내리기
                onSearch("")
            }
            .foregroundColor(.white)
            .opacity(isTextFieldFocused || !searchText.isEmpty ? 1 : 0) // 포커스, 검색어 있을때만 보이기
            .frame(width: isTextFieldFocused || !searchText.isEmpty ? nil : 0) // 포커스, 검색어 있을때만 보이기
            .clipped()
        } /// - HStack
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color.mainColor)
        .frame(height: 50)
        .animation(.easeInOut, value: isTextFieldFocused || !searchText.isEmpty)
    } /// - var body: some View
} /// - struct CustomSearchBarView: View

#Preview {
    CustomSearchBarView(searchText: .constant("Swift"), onSearch: { _ in })
}
