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
    
    // 로딩 상태 관리 (초기, 로딩중, 로드완료)
    @Published var state: ViewState = .idle
    
    // 현재 정렬 상태 관리
    @Published var currentSortOption: SortOption
    
    // 금액 필터
    @Published var minPriceFilter: String = ""
    @Published var maxPriceFilter: String = ""
    
    // 검색, 즐겨찾기 타입 구분
    var viewType: ViewType
    
    // viewType에 따른 탭 타이틀
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
    
    // 검색, 즐겨찾기에 따라 다른 정렬 옵션 표시
    let availableSortOptions: [SortOption]
    
    // 마지막으로 사용된 정렬 옵션
    private var lastUsedSortOption: SortOption
    
    // 로드된 도서 뷰모델 목록 배열
    @Published var allLoadedBookViewModels: [BookItemViewModel] = []
    
    @Published var isLastPage = false
    @Published var isLoadingMore = false
    
    // 외부에서 주입되는 useCase
    private let useCase: BooksListUseCase
    
    // 외부에서 주입되는 favoriteRepository
    private let favoriteRepository: FavoriteRepository
    
    //MARK: - `BooksListViewModel`을 초기화합니다.
    /// - Parameters:
    ///   - useCase: 도서 데이터 로딩을 위한 UseCase
    ///   - initialSortOption: 초기 정렬 옵션
    ///   - availableSortOptions: 사용 가능한 정렬 옵션 목록
    ///   - viewType: 뷰의 타입 (검색 또는 즐겨찾기)
    ///   - favoriteRepository: 즐겨찾기 데이터 관리를 위한 Repository
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
        self.lastUsedSortOption = initialSortOption // 초기화
        
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
}


//MARK: - 도서 목록 가져오는 로직
extension BooksListViewModel {
    //MARK: - 도서 목록 로드
    /// 새로운 검색, 쿼리 또는 정렬 옵션이 변경되면 데이터 초기화 후 새로 로드
    /// 이미 로딩 중이거나 마지막 페이지인 경우 중복 요청 방지
    /// - Parameters:
    ///   - searchText: 검색어
    ///   - page: 로드할 페이지 번호 (기본값: 1)
    ///   - minPrice: 최소 가격 필터 (즐겨잧기에서 사용)
    ///   - maxPrice: 최대 가격 필터 (즐겨잧기에서 사용)
    func loadBooks(searchText: String, page: Int = 1, minPrice: String? = nil, maxPrice: String? = nil) {
        // 새로운 검색이거나, 현재 쿼리 또는 정렬 옵션이 변경되었을 때 초기화
        if searchText != currentQuery || currentSortOption != lastUsedSortOption {
            currentQuery = searchText
            currentPage = 1
            allLoadedBookViewModels = []
            isLastPage = false
        }
        
        // 검색 뷰일 때만 빈 검색어 처리
        if searchText.isEmpty && viewType == .search {
            state = .idle
            return
        }
        
        // 이미 로딩 중이거나 마지막 페이지면 중복 요청 방지
        if isLoadingMore || isLastPage {
            return
        }

        // 로딩 시작 시 상태를 .loading으로 변경
        self.state = .loading
        
        isLoadingMore = true
        
        useCase.execute(query: currentQuery, sort: currentSortOption, page: currentPage, minPrice: minPriceFilter, maxPrice: maxPriceFilter)
            .subscribe(onNext: { [weak self] response in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    
                    /*
                     도서 아이템 뷰에서는 뷰모델을 필요로 하기 때문에
                     전달된 도서 모델별로 뷰모델을 생성하여 새로운 배열을 생성하여 전달
                     */
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
                    
                    // 상태 업데이트
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

        // 마지막 사용 정렬 옵션 업데이트
        lastUsedSortOption = currentSortOption
    }
    
    /// 다음 페이지의 도서 목록을 로드
    /// 이미 로딩 중이거나 마지막 페이지인 경우 중복 요청 방지
    func loadNextPage() {
        guard !isLoadingMore && !isLastPage else { return }
        currentPage += 1
        loadBooks(searchText: currentQuery, page: currentPage, minPrice: minPriceFilter, maxPrice: maxPriceFilter)
    }
}



//MARK: - 즐겨찾기 관련 로직
extension BooksListViewModel {
    /// 가격 필터를 적용하여 도서 목록을 새로고침
    func applyPriceFilter() {
        // 필터 적용 시 즐겨찾기 목록 새로고침
        allLoadedBookViewModels = []
        currentPage = 1
        isLastPage = false
        loadBooks(searchText: currentQuery, minPrice: minPriceFilter, maxPrice: maxPriceFilter)
    }
    
    
    /// 즐겨찾기 목록에서 특정 도서를 제거하는 기능입니다.
    /// - Parameter isbn: 제거할 도서의 ISBN.
    func deleteFromFavorites(isbn: String) {
        if  viewType == .favorite {
            allLoadedBookViewModels.removeAll { $0.book.isbn == isbn }
        }
    }
    
    /// 즐겨찾기된 도서가 있는지 확인하는 기능입니다.
    /// - Returns: 즐겨찾기된 도서가 하나라도 있으면 `true`, 없으면 `false`.
    func hasFavoriteBooks() -> Bool {
        return favoriteRepository.hasFavoriteBooks()
    }
}
