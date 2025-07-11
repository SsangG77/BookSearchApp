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
    var viewType: ViewType
    @State private var searchText: String = ""
    @State private var showingSortOptions = false
    @Environment(\.isSearching) private var isSearching // isSearching 환경 변수 추가
    
    init(viewModel: BooksListViewModel, viewType: ViewType) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.viewType = viewType
    }
    
    //MARK: - body
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
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
            .background(Color.mainColor)
            .opacity(isSearching ? 0 : 1) // 검색 중일 때 투명하게
            .animation(.easeInOut, value: isSearching) // 애니메이션 적용
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(viewType == .search ? "검색" : "즐겨찾기")
                        .jalnanFont(size: 18)
                        .opacity(isSearching ? 0 : 1) // 검색 중일 때 투명하게
                }
            }
            .searchable(
                text: $searchText,
                placement: .navigationBarDrawer(displayMode: .always)
            )
            .onSubmit(of: .search) {
                viewModel.loadBooks(searchText: searchText)
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
        case .loading:
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .success(let books):
            List {
                ForEach(books, id: \.id) { book in
                    BookItemView(
                        viewModel: BookItemViewModel(book: book)
                    )
                    .listRowSeparator(.hidden) // 아이템 구분선 제거
                    .listRowBackground(Color.clear) // 아이템 배경색 투명
                }
            }
            .listStyle(.plain)
        case .error(let message):
            Text(message)
                .jalnanFont(size: 18)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .empty:
            Text("도서가 없어요😢")
                .jalnanFont(size: 17)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}



//MARK: - Preview
#Preview {
    let apiUseCase = APISearchUseCase(
        repository: DIContainer.shared.makeBookRepository()
    )
    
    let viewModel = BooksListViewModel(
        useCase: apiUseCase,
        initialSortOption: .accuracy,
        availableSortOptions: [.accuracy, .latest]
    )
    
    BooksListView(viewModel: viewModel, viewType: .search)
}
