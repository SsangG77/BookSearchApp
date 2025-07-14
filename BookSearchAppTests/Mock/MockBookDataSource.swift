//
//  MockBookDataSource.swift
//  BookSearchAppTests
//
//  Created by 차상진 on 7/12/25.
//

import Foundation
import RxSwift
@testable import BookSearchApp

// 테스트나 개발 중에 사용하는 Mock 데이터 소스
class MockBookDataSource: BookDataSource {
    var mockResponse: Observable<BookSearchResponse>?

    func fetchBooks(query: String, sort: String, page: Int) -> Observable<BookSearchResponse> {
        if let response = mockResponse {
            return response
        } else {
            // 기본 샘플 데이터 반환 (mockResponse가 설정되지 않았을 경우)
            let sampleBooks: [BookItemModel] = [
                BookItemModel(id: UUID(), title: "Mock Book 1", contents: "Mock contents 1", url: "http://example.com", isbn: "12345", authors: ["Mock Author 1"], publisher: "Mock Publisher 1", translators: [], price: 10000, salePrice: 9000, thumbnail: "https://via.placeholder.com/150", status: "정상", datetime: Date()),
                BookItemModel(id: UUID(), title: "Mock Book 2", contents: "Mock contents 2", url: "http://example.com", isbn: "12346", authors: ["Mock Author 2"], publisher: "Mock Publisher 2", translators: [], price: 12000, salePrice: 11000, thumbnail: "https://via.placeholder.com/150", status: "정상", datetime: Date()),
                BookItemModel(id: UUID(), title: "Mock Book 3", contents: "Mock contents 3", url: "http://example.com", isbn: "12347", authors: ["Mock Author 3"], publisher: "Mock Publisher 3", translators: [], price: 15000, salePrice: 14000, thumbnail: "https://via.placeholder.com/150", status: "절판", datetime: Date())
            ]
            
            let meta = Meta(isEnd: page >= 3, pageableCount: 3, totalCount: 9) // 예시 메타 데이터
            let response = BookSearchResponse(meta: meta, documents: sampleBooks)
            
            return Observable.just(response).delay(.seconds(1), scheduler: MainScheduler.instance) // 실제 네트워크처럼 딜레이 추가
        }
    }
}
