//
//  BooksListViewModel.swift
//  BookSearchApp
//
//  Created by 차상진 on 7/11/25.
//

import Foundation
import RxSwift

// MARK: - ViewState
enum ViewState: Equatable {
    static func == (lhs: ViewState, rhs: ViewState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle), (.loading, .loading), (.empty, .empty):
            return true
        case (.success(let lhsBooks), .success(let rhsBooks)):
            return lhsBooks == rhsBooks
        case (.error(let lhsError), .error(let rhsError)):
            return lhsError == rhsError
        default:
            return false
        }
    }
    
    case idle
    case loading
    case success([BookItemModel])
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
    
    init(useCase: BooksListUseCase, initialSortOption: SortOption, availableSortOptions: [SortOption]) {
        self.useCase = useCase
        self.currentSortOption = initialSortOption
        self.availableSortOptions = availableSortOptions
    }
    
    func loadBooks(searchText: String, page: Int = 1) {
        if searchText.isEmpty {
            state = .idle
            return
        }
        
        state = .loading
        
        useCase.execute(query: searchText, sort: currentSortOption, page: page)
            .subscribe(onNext: { [weak self] models in
                DispatchQueue.main.async {
                    if models.isEmpty {
                        self?.state = .empty
                    } else {
                        self?.state = .success(models)
                    }
                }
            }, onError: { [weak self] error in
                DispatchQueue.main.async {
                    self?.state = .error("네트워크 에러입니다.")
                }
            })
            .disposed(by: disposeBag)
    }
}