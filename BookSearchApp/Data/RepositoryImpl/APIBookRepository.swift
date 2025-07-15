//
//  APIBookRepository.swift
//  BookSearchApp
//
//  Created by 차상진 on 7/12/25.
//

import Foundation
import RxSwift


//MARK: - Kakao API를 사용하는 리포지토리 구현체
class APIBookFetchRepository: BookFetchRepository {
    private let dataSource: BookDataSource

    init(dataSource: BookDataSource) {
        self.dataSource = dataSource
    }

    //MARK: - dataSource의 데이터 전달
    /// - Parameters:
    ///   - query: 검색어
    ///   - sort: 정렬 상태
    ///   - page: 로드 페이지
    /// - Returns: BookSearchResponse를 방출하는 객체
    func fetchBooks(query: String, sort: String, page: Int) -> Observable<BookSearchResponse> {
        return dataSource.fetchBooks(query: query, sort: sort, page: page)
    }
}
