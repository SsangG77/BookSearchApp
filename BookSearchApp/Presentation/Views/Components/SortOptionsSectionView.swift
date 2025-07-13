//
//  SortOptionsSectionView.swift
//  BookSearchApp
//
//  Created by 차상진 on 7/11/25.
//

import SwiftUI

struct SortOptionsSectionView: View {
    @ObservedObject var viewModel: BooksListViewModel
    @Binding var showingSortOptions: Bool
    let searchText: String

    //  body
    var body: some View {
        VStack(spacing: 8) {
            sortHeaderSection // Spacer() + 정렬 버튼

            if showingSortOptions { // 정렬 종류 리스트 나타남
                sortDropdownSection // 정렬 종류 리스트
            }
        }
        .animation(.easeInOut(duration: 0.2), value: showingSortOptions)
    }

    // Spacer() + 정렬 버튼
    private var sortHeaderSection: some View {
        HStack {
            Spacer()
            sortButton
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }

    // 정렬 버튼
    private var sortButton: some View {
        Button {
            withAnimation { showingSortOptions.toggle() }
        } label: {
            HStack(spacing: 4) {
                Text(viewModel.currentSortOption.displayName) // 선택된 정렬 표시
                    .jalnanFont(size: 14)
                    .foregroundColor(.white)

                Image(systemName: showingSortOptions ? "chevron.up" : "chevron.down") // 정렬 리스트 화살표
                    .font(.system(size: 12))
                    .foregroundColor(.white)
            } /// - HStack
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.white.opacity(0.2))
            .cornerRadius(8)
        } /// - label
    } /// - var sortButton: some View

    // 정렬 종류 리스트
    private var sortDropdownSection: some View {
        VStack(spacing: 4) {
            //정렬 종류 리스트, 뷰에 따라 다름
            ForEach(viewModel.availableSortOptions, id: \.self) { option in
                Button {
                    viewModel.currentSortOption = option // 선택된 정렬 종류 할당
                    viewModel.loadBooks(searchText: searchText) //정렬 종류가 변경되면 다시 API 호출
                    showingSortOptions = false // 정렬 종류 탭하면 리스트 숨기기
                } label: {
                    HStack {
                        Text(option.displayName) // ForEach에 따라 정렬 종류 표시
                            .jalnanFont(size: 14)

                        Spacer()

                        if viewModel.currentSortOption == option { // 선택된 종류와 같은 옵션이면 체크 표시
                            Image(systemName: "checkmark")
                                .font(.system(size: 12))
                                .foregroundColor(.white)
                        }
                    } // HStack
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(6)
                } /// - label
            } /// - ForEach
        } /// - VStack
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
    } /// - var sortDropdownSection: some View
} /// - struct SortOptionsSectionView: View
