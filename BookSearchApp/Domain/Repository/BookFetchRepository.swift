//
//  BookRepository.swift
//  BookSearchApp
//
//  Created by 차상진 on 7/10/25.
//

import Foundation
import RxSwift

// MARK: - 도서 목록 불러오기 리포지토리 프로토콜
protocol BookFetchRepository {
    func fetchBooks(query: String, sort: String, page: Int) -> Observable<BookSearchResponse>
}



