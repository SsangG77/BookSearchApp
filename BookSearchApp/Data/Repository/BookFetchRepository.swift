//
//  BookRepository.swift
//  BookSearchApp
//
//  Created by 차상진 on 7/10/25.
//

import Foundation
import RxSwift

// MARK: - Repository Protocol
protocol BookFetchRepository {
    func fetchBooks(query: String, sort: String, page: Int) -> Observable<BookSearchResponse>
}



