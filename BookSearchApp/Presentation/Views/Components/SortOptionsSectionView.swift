//
//  SortOptionsSectionView.swift
//  BookSearchApp
//
//  Created by 차상진 on 7/11/25.
//

import SwiftUI

//MARK: - 정렬 옵셕 선택 뷰
struct SortOptionsSectionView: View {
    @ObservedObject var viewModel: BooksListViewModel
    
    // 버튼 보여주는 플래그 변수
    @State private var showingSortOptions: Bool = false
    @State private var showingPriceFilter: Bool = false
    
    let searchText: String
    let viewType: ViewType

    //  body
    var body: some View {
        VStack(spacing: 8) {
            sortHeaderSection // Spacer + 정렬 버튼

            if showingSortOptions { // 정렬 종류 리스트 보여주기
                sortDropdownSection // 정렬 종류 리스트
            }
            if showingPriceFilter { // 금액 필터 뷰 보여주기
                priceFilterSection // 금액 필터 뷰
            }
        }
        .animation(.easeInOut(duration: 0.2), value: showingSortOptions || showingPriceFilter)
    }

    //MARK: - Spacer + 정렬 버튼
    private var sortHeaderSection: some View {
        HStack {
            Spacer()
            
            if viewType == .favorite { // 즐겨찾기 뷰에서는 가격 필터 버튼 보여주기
                priceSelectButton // 가격 필터 버튼
            }
            sortButton // 정렬 선택 버튼
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }

    //MARK: - 정렬 버튼 리스트
    private var sortButton: some View {
        Button {
            withAnimation {
                showingSortOptions.toggle()
                if showingSortOptions { // 정렬 옵션이 열릴 때 금액 필터 닫기
                    showingPriceFilter = false
                }
            }
        } label: {
            HStack(spacing: 4) {
                Text(viewModel.currentSortOption.displayName) // 선택된 정렬 이름 표시
                    .jalnanFont(size: 14)
                    .foregroundColor(.white)

                Image(systemName: showingSortOptions ? "chevron.up" : "chevron.down") // 정렬 리스트 화살표
                    .font(.system(size: 12))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.white.opacity(0.2))
            .cornerRadius(8)
        }
    }
    
    //MARK: - 금액 선택 버튼
    private var priceSelectButton: some View {
        Button {
            withAnimation {
                showingPriceFilter.toggle()
                if showingPriceFilter { // 금액 필터가 열릴 때 정렬 옵션 리스트 닫기
                    showingSortOptions = false
                }
            }
            
        } label: {
            HStack(spacing: 4) {
                Text("금액 필터") // 선택된 정렬 표시
                    .jalnanFont(size: 14)
                    .foregroundColor(.white)

                Image(systemName: showingSortOptions ? "chevron.up" : "chevron.down") // 정렬 리스트 화살표
                    .font(.system(size: 12))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.white.opacity(0.2))
            .cornerRadius(8)
        }
    }

    //MARK: - 정렬 종류 리스트
    private var sortDropdownSection: some View {
        VStack(spacing: 4) {
            //정렬 종류 리스트, 뷰에 따라 다름
            ForEach(viewModel.availableSortOptions, id: \.self) { option in
                Button {
                    viewModel.currentSortOption = option // 선택된 정렬 종류 할당
                    viewModel.loadBooks(searchText: searchText) //정렬 종류가 변경되면 다시 API 호출
                    showingSortOptions = false // 정렬 종류 리스트 숨기기
                    showingPriceFilter = false // 금액 드롭다운 숨기기
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

    //MARK: - 금액 필터 입력 뷰
    private var priceFilterSection: some View {
        VStack(spacing: 4) {
            HStack {
                TextField("원가 최소 금액", text: $viewModel.minPriceFilter)
                    .keyboardType(.numberPad)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(8)
                    .foregroundColor(.white)
                    .jalnanFont(size: 14)

                Text("~")
                    .jalnanFont(size: 14)
                    .foregroundColor(.white)

                TextField("원가 최대 금액", text: $viewModel.maxPriceFilter)
                    .keyboardType(.numberPad)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(8)
                    .foregroundColor(.white)
                    .jalnanFont(size: 14)
                
                
                Button {
                    viewModel.applyPriceFilter()
                    showingSortOptions = false // 정렬 종류 리스트 숨기기
                    showingPriceFilter = false // 금액 드롭다운 숨기기
                } label: {
                    HStack {
                        Text("적용")
                            .jalnanFont(size: 14)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(6)
                }
                
                
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 8)
        }
    }
}
