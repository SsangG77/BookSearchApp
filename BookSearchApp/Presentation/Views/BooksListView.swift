//
//  BooksListView.swift
//  BookSearchApp
//
//  Created by 차상진 on 7/10/25.
//

import SwiftUI
import RxSwift
import RxCocoa

enum ViewType {
    case search, favorite
}

/// 재사용 가능한 도서 리스트뷰
struct BooksListView: View {
    @StateObject var viewModel: BooksListViewModel
    @State private var searchText: String = ""
    @State private var showingSortOptions = false
    
    init(viewModel: BooksListViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    //MARK: - body
    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
                
                // 최상단 뷰 제목
                Text(viewModel.viewTitle)
                    .jalnanFont(size: 22) // 여기어때 폰트 커스텀 modifier
                    .padding(.top, 10)
                
                // 검색필드 뷰
                CustomSearchBarView(
                    searchText: $searchText,
                    onSearch: { query in
                        viewModel.loadBooks(searchText: query)
                    }
                )
                
                // 정렬 선택 뷰
                SortOptionsSectionView(
                    viewModel: viewModel,
                    showingSortOptions: $showingSortOptions,
                    searchText: searchText
                )
                .padding(.bottom, 7)
                
                // 컨텐츠 영역
                contentView
            }
            .background(Color.mainColor) // 배경색 적용
            .frame(maxWidth: .infinity, maxHeight: .infinity) // 전체 공간 채우기
            .onAppear {
                // 즐겨찾기 뷰일 경우 바로 로드
                if viewModel.viewType == .favorite {
                    viewModel.loadBooks(searchText: "")
                }
            }
        } /// - NavigationView
        .accentColor(.mainColor)
    } /// - var body: some View
    
    @ViewBuilder
    private var contentView: some View {
        
        switch viewModel.state {
            
        // 초기 상태
        case .idle:
            // 초기 뷰에 보이는 메시지
            Text(viewModel.viewType == .search ? "검색어를 입력해주세요." : "♥ 눌러 즐겨찾기 추가하기")
                .jalnanFont(size: 18)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.mainColor) // 배경색 적용
            
        // 로딩 상태
        case .loading:
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.mainColor) // 배경색 적용
            
        // 로딩 완료 상테
        case .loaded:
            List {
                ForEach(viewModel.allLoadedBookViewModels, id: \.id) { itemViewModel in
                    NavigationLink(
                        destination: BookDetailView(
                            viewModel: itemViewModel
                        )
                    ) {
                        BookItemView(
                            viewModel: itemViewModel
                        )
                    }
                    .listRowSeparator(.hidden) // 아이템 구분선 제거
                    .listRowBackground(Color.clear) // 아이템 배경색 투명
                    .overlay(Color.clear)
                    .onAppear { // 마지막 아이템이 나타날 때 다음 페이지 로드
                        if itemViewModel == viewModel.allLoadedBookViewModels.last
                            && !viewModel.isLoadingMore && !viewModel.isLastPage
                        {
                            viewModel.loadNextPage()
                        }
                    }
                } /// - ForEach
                
                if viewModel.isLoadingMore {
                    ProgressView()
                        .listBottomEffect()
                } else if viewModel.isLastPage {
                    Text("마지막 페이지 입니다.")
                        .jalnanFont(size: 14)
                        .listBottomEffect()
                }
            } /// - List
            .listStyle(.plain)
            .background(Color.mainColor)
        
        // ❌ 에러 발생
        case .error(let message):
            Text(message)
                .jalnanFont(size: 18)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.mainColor) // 배경색 적용
        
        // 데이터가 없을 때
        case .empty:
            Text("도서가 없어요😢")
                .jalnanFont(size: 17)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.mainColor) // 배경색 적용
        }
    
    }
    
}


//MARK: - Preview
#Preview {
    let apiUseCase = APISearchUseCase(
        repository: DIContainer.shared.makeAPIBookRepository()
    )
    
    let viewModel = BooksListViewModel(
        useCase: apiUseCase,
        initialSortOption: .accuracy,
        availableSortOptions: [.accuracy, .latest],
        viewType: .search, favoriteRepository: DIContainer.shared.makeFavoriteRepository()
    )
    
    BooksListView(viewModel: viewModel)
}