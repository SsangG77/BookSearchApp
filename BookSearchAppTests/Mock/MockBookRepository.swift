//
//  MockBookRepository.swift
//  BookSearchAppTests
//
//  Created by 차상진 on 7/12/25.
//

import Foundation
import RxSwift

// Mock 데이터를 사용하는 리포지토리
class MockBookRepository: BookRepository {
    private let dataSource: BookDataSource

    init(dataSource: BookDataSource) {
        self.dataSource = dataSource
    }

    func fetchBooks(query: String, sort: String, page: Int) -> Observable<BookSearchResponse> {
        return dataSource.fetchBooks(query: query, sort: sort, page: page)
    }
}
