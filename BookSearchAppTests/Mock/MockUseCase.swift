//
//  MockUseCase.swift
//  BookSearchAppTests
//
//  Created by 차상진 on 7/14/25.
//

import Foundation
import RxSwift

@testable import BookSearchApp

class MockUseCase: BooksListUseCase {
    let repository: BookFetchRepository
    
    // 테스트를 위해 execute 호출 시 인자를 저장할 프로퍼티 추가
    var lastExecutedQuery: String? = nil
    var lastExecutedSort: SortOption? = nil
    var lastExecutedPage: Int? = nil
    var lastExecutedMinPrice: String? = nil
    var lastExecutedMaxPrice: String? = nil
    
    init(repository: BookFetchRepository) {
        self.repository = repository
    }
    
    func execute(query: String, sort: SortOption, page: Int, minPrice: String, maxPrice: String) -> Observable<BookSearchResponse> {
        // 인자 저장
        self.lastExecutedQuery = query
        self.lastExecutedSort = sort
        self.lastExecutedPage = page
        self.lastExecutedMinPrice = minPrice
        self.lastExecutedMaxPrice = maxPrice
        
        // 기존 로직 유지
        return repository.fetchBooks(query: query, sort: sort.rawValue, page: page)
    }
}
