//
//  BooksListViewModel.swift
//  BookSearchApp
//
//  Created by 차상진 on 7/11/25.
//

import Foundation
import RxSwift
import SwiftUI

// MARK: - BooksListViewModel
class BooksListViewModel: ObservableObject {
    private let disposeBag = DisposeBag()
    @Published var state: ViewState = .idle
    @Published var currentSortOption: SortOption
    
    // 금액 필터
    @Published var minPriceFilter: String = ""
    @Published var maxPriceFilter: String = ""
    
    
    private let useCase: BooksListUseCase
    let availableSortOptions: [SortOption]
    var viewType: ViewType
    var viewTitle: String {
        switch viewType {
        case .search:
            return "검색"
        case .favorite:
            return "즐겨찾기"
        }
    }
    
    // 페이징 관련 상태
    private var currentPage = 1
    private var currentQuery = ""
    @Published var allLoadedBookViewModels: [BookItemViewModel] = []
    @Published var isLastPage = false
    @Published var isLoadingMore = false
    
    private let favoriteRepository: FavoriteRepository
    
    init(
        useCase: BooksListUseCase,
        initialSortOption: SortOption,
        availableSortOptions: [SortOption],
        viewType: ViewType,
        favoriteRepository: FavoriteRepository
    ) {
        self.useCase = useCase
        self.currentSortOption = initialSortOption
        self.availableSortOptions = availableSortOptions
        self.viewType = viewType
        self.favoriteRepository = favoriteRepository
        
        // 즐겨찾기 뷰 타입일 경우, 즐겨찾기 변경 이벤트를 구독하여 UI 실시간 업데이트
        favoriteRepository.favoriteBooksChanged
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                if self.viewType == .favorite {
                    print("Favorite books changed, reloading favorites.")
                    // 즐겨찾기 목록을 새로고침하기 전에 기존 데이터를 초기화
                    self.allLoadedBookViewModels = []
                    self.currentPage = 1
                    self.isLastPage = false
                    self.loadBooks(searchText: "") // 즐겨찾기 목록 새로고침
                }
            })
            .disposed(by: disposeBag)
    }
    
    func loadBooks(searchText: String, page: Int = 1, minPrice: String? = nil, maxPrice: String? = nil) {
        // 새로운 검색이거나, 현재 쿼리가 변경되었을 때 초기화
        if searchText != currentQuery {
            currentQuery = searchText
            currentPage = 1
            allLoadedBookViewModels = []
            isLastPage = false
        }
        
        if searchText.isEmpty && viewType == .search { // 검색 뷰일 때만 빈 검색어 처리
            state = .idle
            return
        }
        
        if isLoadingMore || isLastPage { return } // 이미 로딩 중이거나 마지막 페이지면 중복 요청 방지
        
        isLoadingMore = true
        
        print("BooksListViewModel: useCase.execute()")
        useCase.execute(query: currentQuery, sort: currentSortOption, page: currentPage, minPrice: minPriceFilter, maxPrice: maxPriceFilter)
            .subscribe(onNext: { [weak self] response in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    
                    let newViewModels = response.documents.map { book in
                        BookItemViewModel(
                            book: book,
                            favoriteRepository: self.favoriteRepository,
                            deleteItem: { isbn in
                                self.deleteFromFavorites(isbn: isbn)
                            }
                        )
                    }
                    self.allLoadedBookViewModels.append(contentsOf: newViewModels)
                    print("BooksListViewModel: allLoadedBookViewModels count after append: \(self.allLoadedBookViewModels.count)")
                    
                    self.isLastPage = response.meta.isEnd
                    self.isLoadingMore = false
                    
                    if self.allLoadedBookViewModels.isEmpty {
                        self.state = .empty
                    } else {
                        self.state = .loaded // loaded 상태로 변경
                    }
                }
            }, onError: { [weak self] error in
                DispatchQueue.main.async {
                    self?.isLoadingMore = false
                    self?.state = .error("데이터 로드 중 에러 발생: \(error.localizedDescription)")
                    print("BooksListViewModel loadBooks Error: \(error)")
                }
            })
            .disposed(by: disposeBag)
    }
    
    func applyPriceFilter() {
        // 필터 적용 시 즐겨찾기 목록 새로고침
        allLoadedBookViewModels = []
        currentPage = 1
        isLastPage = false
        loadBooks(searchText: currentQuery, minPrice: minPriceFilter, maxPrice: maxPriceFilter)
    }
    
    func loadNextPage() {
        guard !isLoadingMore && !isLastPage else { return }
        currentPage += 1
        loadBooks(searchText: currentQuery, page: currentPage, minPrice: minPriceFilter, maxPrice: maxPriceFilter)
    }
    
    func deleteFromFavorites(isbn: String) {
        if  viewType == .favorite {
            allLoadedBookViewModels.removeAll { $0.book.isbn == isbn }
        }
    }
    
}
