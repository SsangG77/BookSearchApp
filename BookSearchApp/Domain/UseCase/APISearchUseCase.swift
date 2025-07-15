//
//  APISearchUseCase.swift
//  BookSearchApp
//
//  Created by 차상진 on 7/11/25.
//

import Foundation
import RxSwift

//MARK: - API를 통해 도서 검색 UseCase 구현체
class APISearchUseCase: BooksListUseCase {
    private let repository: BookFetchRepository

    init(repository: BookFetchRepository) {
        self.repository = repository
    }

    /// 주어진 검색 조건에 따라 도서 목록을 비동기적으로 조회
    /// - Parameters:
    ///   - query: 검색어
    ///   - sort: 정렬 옵션 (정확도순, 발간일순)
    ///   - page: 페이지
    ///   - minPrice: (즐겨찾기에서 사용) 최소 가격 필터
    ///   - maxPrice: (즐겨찾기에서 사용) 최대 가격 필터
    /// - Returns: Observable<BookSearchResponse>
    func execute(query: String, sort: SortOption, page: Int, minPrice: String, maxPrice: String) -> Observable<BookSearchResponse> {
        return repository.fetchBooks(query: query, sort: sort.queryValue, page: page)
    }
}
