//
//  BooksListViewModel.swift
//  BookSearchApp
//
//  Created by 차상진 on 7/11/25.
//

import Foundation
import RxSwift
import SwiftUI

// MARK: - ViewState
enum ViewState: Equatable {
    static func == (lhs: ViewState, rhs: ViewState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle), (.loading, .loading), (.empty, .empty):
            return true
        case (.error(let lhsError), .error(let rhsError)):
            return lhsError == rhsError
        default:
            return false
        }
    }
    
    case idle
    case loading
    case loaded
    case error(String)
    case empty
}

// MARK: - BooksListViewModel
class BooksListViewModel: ObservableObject {
    private let disposeBag = DisposeBag()
    @Published var state: ViewState = .idle
    @Published var currentSortOption: SortOption
    
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
    @Published var allLoadedBooks: [BookItemModel] = [] // @Published로 변경
    @Published var isLastPage = false
    @Published var isLoadingMore = false
    
    init(useCase: BooksListUseCase, initialSortOption: SortOption, availableSortOptions: [SortOption], viewType: ViewType) {
        self.useCase = useCase
        self.currentSortOption = initialSortOption
        self.availableSortOptions = availableSortOptions
        self.viewType = viewType
        
        
    }
    
    func loadBooks(searchText: String, page: Int = 1) {
        print("\(viewType) 뷰모델: loadBooks()")
        // 새로운 검색이거나, 정렬 옵션이 변경되었을 때 초기화
        if page == 1 { // 페이지가 1이면 새로운 검색/정렬 시작으로 간주
            currentQuery = searchText
            currentPage = 1
            allLoadedBooks = []
            isLastPage = false
        }
        
        if searchText.isEmpty && viewType == .search { // 검색 뷰일 때만 빈 검색어 처리
            state = .idle
            return
        }
        
        if isLoadingMore || isLastPage { return } // 이미 로딩 중이거나 마지막 페이지면 중복 요청 방지
        
        isLoadingMore = true
        
        useCase.execute(query: currentQuery, sort: currentSortOption, page: currentPage)
            .subscribe(onNext: { [weak self] response in
                print("BooksListViewModel.loagBoosts() onNext")
                print(response)
                print("")
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    
                    self.allLoadedBooks.append(contentsOf: response.documents)
                    self.isLastPage = response.meta.isEnd
                    self.isLoadingMore = false
                    
                    if self.allLoadedBooks.isEmpty {
                        self.state = .empty
                    } else {
                        self.state = .loaded // loaded 상태로 변경
                    }
                }
            }, onError: { [weak self] error in
                DispatchQueue.main.async {
                    self?.isLoadingMore = false
                    self?.state = .error("네트워크 에러입니다.")
                }
            })
            .disposed(by: disposeBag)
    }
    
    func loadNextPage() {
        guard !isLoadingMore && !isLastPage else { return }
        currentPage += 1
        loadBooks(searchText: currentQuery, page: currentPage)
    }
    

}
