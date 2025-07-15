//
//  KakaoBookDataSource.swift
//  BookSearchApp
//
//  Created by 차상진 on 7/12/25.
//

import Foundation
import RxSwift

//MARK: - 실제 Kakao API를 사용하는 데이터 소스
class KakaoBookDataSource: BookDataSource {
    private let apiService: APIService

    init(apiService: APIService) {
        self.apiService = apiService
    }

    // 도서 데이터 비동기적으로 조회
    func fetchBooks(query: String, sort: String, page: Int) -> Observable<BookSearchResponse> {
        return apiService.searchBooks(query: query, sort: sort, page: page)
    }
}


