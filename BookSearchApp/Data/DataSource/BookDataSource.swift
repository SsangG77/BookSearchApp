//
//  BookDataSource.swift
//  BookSearchApp
//
//  Created by 차상진 on 7/12/25.
//

import Foundation
import RxSwift

protocol BookDataSource {
    func fetchBooks(query: String, sort: String, page: Int) -> Observable<BookSearchResponse>
}
