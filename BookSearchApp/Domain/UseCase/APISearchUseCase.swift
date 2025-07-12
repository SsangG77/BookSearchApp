//
//  APISearchUseCase.swift
//  BookSearchApp
//
//  Created by 차상진 on 7/11/25.
//

import Foundation
import RxSwift

// MARK: - 도서 검색 UseCase 프로토콜 구현체
class APISearchUseCase: BooksListUseCase {
    private let repository: BookFetchRepository

    init(repository: BookFetchRepository) {
        self.repository = repository
    }

    func execute(query: String, sort: SortOption, page: Int) -> Observable<BookSearchResponse> {
        return repository.fetchBooks(query: query, sort: sort.queryValue, page: page)
    }
}
