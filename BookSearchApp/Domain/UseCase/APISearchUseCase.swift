//
//  APISearchUseCase.swift
//  BookSearchApp
//
//  Created by 차상진 on 7/11/25.
//

import Foundation
import RxSwift

class APISearchUseCase: BooksListUseCase {
    private let repository: BookRepository

    init(repository: BookRepository) {
        self.repository = repository
    }

    func execute(query: String, sort: SortOption, page: Int) -> Observable<[BookItemModel]> {
        return repository.fetchBooks(query: query, sort: sort.queryValue, page: page)
    }
}
