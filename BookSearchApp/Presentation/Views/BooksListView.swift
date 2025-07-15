//
//  BooksListView.swift
//  BookSearchApp
//
//  Created by 차상진 on 7/10/25.
//

import SwiftUI
import RxSwift




/// 재사용 가능한 도서 리스트뷰
struct BooksListView: View {
    @StateObject var viewModel: BooksListViewModel
    @State private var searchText: String = ""
    
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
                    viewType: $viewModel.viewType,
                    onSearch: { query in
                        viewModel.loadBooks(searchText: query)
                    }
                )
                
                // 정렬 선택 뷰
                SortOptionsSectionView(
                    viewModel: viewModel,
                    searchText: searchText,
                    viewType: viewModel.viewType
                )
                .padding(.bottom, 7)
                
                // 컨텐츠 영역
                contentView
            }
            .background(Color.mainColor) // 배경색 적용
            .frame(maxWidth: .infinity, maxHeight: .infinity) // 전체 공간 채우기
            .animation(.easeInOut(duration: 0.5), value: viewModel.state) // 뷰모델 상태 변화에 애니메이션 적용
            .onAppear {
                // 즐겨찾기 뷰일 경우
                if viewModel.viewType == .favorite {
                    // 즐겨찾기된 도서가 있는지 먼저 확인
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
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(0..<5) { _ in
                        BookItemLoadingSkeleton()
                            .frame(width: UIScreen.main.bounds.width * 0.85)
                            .padding(.trailing, 20)
                    }
                }
                .padding(.horizontal, 5)
            }
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
        
        // 에러 발생
        case .error(let message):
            VStack(spacing: 20) {
                Text(message)
                    .jalnanFont(size: 18)
                
                Button(action: {
                    // 리로드 버튼 탭 시 데이터 다시 로드
                    viewModel.loadBooks(searchText: searchText)
                }) {
                    Text("다시 시도")
                        .jalnanFont(size: 16, color: .white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.accentColor)
                        .cornerRadius(10)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.mainColor) // 배경색 적용
        
        // 데이터가 없을 때
        case .empty:
            Text(viewModel.viewType == .search ? "검색결과가 없어요😢" : "♥ 눌러 즐겨찾기 추가하기")
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
