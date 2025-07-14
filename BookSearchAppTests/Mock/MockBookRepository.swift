//
//  MockBookRepository.swift
//  BookSearchAppTests
//
//  Created by chasangjin on 7/14/25.
//

import Foundation
import RxSwift
@testable import BookSearchApp

class MockBookRepository: BookFetchRepository {
    let dataSource: BookDataSource
    
    init(dataSource: BookDataSource) {
        self.dataSource = dataSource
    }

    func fetchBooks(query: String, sort: String, page: Int) -> Observable<BookSearchResponse> {
        return dataSource.fetchBooks(query: query, sort: sort, page: page)
    }
}
