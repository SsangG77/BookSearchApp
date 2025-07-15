//
//  MockBookFetchRepository.swift
//  BookSearchAppTests
//
//  Created by 차상진 on 7/15/25.
//

import Foundation
import RxSwift
@testable import BookSearchApp

class MockBookFetchRepository: BookFetchRepository {
    var fetchBooksResult: Observable<BookSearchResponse>!

    func fetchBooks(query: String, sort: String, page: Int) -> Observable<BookSearchResponse> {
        return fetchBooksResult
    }
}
