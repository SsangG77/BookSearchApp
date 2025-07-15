//
//  CustomSearchBarView.swift
//  BookSearchApp
//
//  Created by 차상진 on 7/11/25.
//

import SwiftUI


//MARK: - 리스트뷰에서 검색 부분을 담당하는 뷰
struct CustomSearchBarView: View {
    @Binding var searchText: String // 바인딩된 검색어
    @Binding var viewType: ViewType // 리스트뷰의 타입 (검색 or 즐겨찾기)
    let onSearch: (String) -> Void // 검색 버튼을 탭할시 실행할 클로저
    @FocusState private var isTextFieldFocused: Bool // TxtField에 포커스 되어있는지 확인

    var body: some View {
        HStack {
            TextField("검색어를 입력하세요", text: $searchText)
                .padding(8)
                .background(Color.white.opacity(0.4))
                .cornerRadius(12)
                .foregroundColor(.white) // searchText 색상
                .accentColor(.white) // 커서 색상
                .focused($isTextFieldFocused) // 포커스 제어
                .onSubmit(of: .text) { // 키보드 엔터 입력시 클로저 실행
                    onSearch(searchText)
                }
            
            Button("취소") {
                searchText = ""
                isTextFieldFocused = false // 키보드 내리기
                
                // 즐겨찾기 뷰에서는 취소버튼을 누르면 빈 검색어 전달하여 전체 리스트 로드
                if viewType == .favorite {
                    onSearch("")
                }
            }
            .foregroundColor(.white)
            .opacity(isTextFieldFocused || !searchText.isEmpty ? 1 : 0) // 포커스, 검색어 있을때만 보이기
            .frame(width: isTextFieldFocused || !searchText.isEmpty ? nil : 0) // 포커스, 검색어 있을때만 보이기
            .clipped()
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color.mainColor)
        .frame(height: 50)
        .animation(.easeInOut, value: isTextFieldFocused || !searchText.isEmpty)
    }
}

#Preview {
    CustomSearchBarView(searchText: .constant("Swift"), viewType: .constant(.favorite), onSearch: { _ in })
}
