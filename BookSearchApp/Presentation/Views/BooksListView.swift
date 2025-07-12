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
                Text(viewModel.viewTitle)
                    .jalnanFont(size: 22)
                
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
                // 즐겨찾기 뷰일 경우 초기 로드
                if viewModel.viewType == .favorite {
                    viewModel.loadBooks(searchText: "")
                }
            }
        }
    }
    
    @ViewBuilder
    private var contentView: some View {
        
        switch viewModel.state {
        case .idle:
            // 초기 상태 (아무것도 표시하지 않거나, 검색을 유도하는 메시지 표시 가능)
            Text("검색어를 입력해주세요.")
                .jalnanFont(size: 18)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.mainColor) // 배경색 적용
        case .loading:
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.mainColor) // 배경색 적용
        case .loaded:
            List {
                ForEach(viewModel.allLoadedBooks, id: \.id) { book in
                    BookItemView(
                        viewModel: BookItemViewModel(
                            book: book,
                            favoriteRepository: DIContainer.shared.makeFavoriteRepository()
                        )
                    )
                    .listRowSeparator(.hidden) // 아이템 구분선 제거
                    .listRowBackground(Color.clear) // 아이템 배경색 투명
                    .onAppear { // 마지막 아이템이 나타날 때 다음 페이지 로드
                        if book == viewModel.allLoadedBooks.last && !viewModel.isLoadingMore && !viewModel.isLastPage {
                            viewModel.loadNextPage()
                        }
                    }
                }
                
                if viewModel.isLoadingMore {
//                    ProgressView()
//                        .frame(width: UIScreen.main.bounds.width)
//                        .padding()
//                        .background(Color.mainColor) // 배경색 적용
//                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
//                        .listRowSeparator(.hidden)
                    ProgressView()
                        .listBottomEffect()
                } else if viewModel.isLastPage {
                    Text("마지막 페이지 입니다.")
                        .jalnanFont(size: 14)
                        .listBottomEffect()
//                        .frame(width: UIScreen.main.bounds.width)
//                        .background(Color.mainColor) // 배경색 적용
//                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
//                        .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
            .background(Color.mainColor)
        case .error(let message):
            Text(message)
                .jalnanFont(size: 18)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.mainColor) // 배경색 적용
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
        viewType: .search
    )
    
    BooksListView(viewModel: viewModel)
}
