//
//  BooksListUseCase.swift
//  BookSearchApp
//
//  Created by 차상진 on 7/11/25.
//

import Foundation
import RxSwift

// MARK: - UseCase 프로토콜
protocol BooksListUseCase {
    func execute(query: String, sort: SortOption, page: Int) -> Observable<BookSearchResponse>
}
