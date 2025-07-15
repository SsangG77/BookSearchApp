//
//  BookDataSource.swift
//  BookSearchApp
//
//  Created by 차상진 on 7/12/25.
//

import Foundation
import RxSwift


//MARK: - 도서 목록 불러오는 프로토콜
protocol BookDataSource {
    func fetchBooks(query: String, sort: String, page: Int) -> Observable<BookSearchResponse>
}
