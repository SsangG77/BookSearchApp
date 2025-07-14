//
//  APIBookRepository.swift
//  BookSearchApp
//
//  Created by 차상진 on 7/12/25.
//

import Foundation
import RxSwift


// 실제 API를 사용하는 리포지토리
class APIBookFetchRepository: BookFetchRepository {
    private let dataSource: BookDataSource

    init(dataSource: BookDataSource) {
        self.dataSource = dataSource
    }

    func fetchBooks(query: String, sort: String, page: Int) -> Observable<BookSearchResponse> {
        return dataSource.fetchBooks(query: query, sort: sort, page: page)
    }
}
