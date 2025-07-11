//
//  BookRepository.swift
//  BookSearchApp
//
//  Created by 차상진 on 7/10/25.
//

import Foundation
import RxSwift

// MARK: - Data Layer (DataSource Protocol)
protocol BookDataSource {
    func fetchBooks(query: String, sort: String, page: Int) -> Observable<[BookItemModel]>
}

// MARK: - Data Layer (DataSource Implementations)

// 실제 Kakao API를 사용하는 데이터 소스
class KakaoBookDataSource: BookDataSource {
    private let apiService: APIService

    init(apiService: APIService) {
        self.apiService = apiService
    }

    func fetchBooks(query: String, sort: String, page: Int) -> Observable<[BookItemModel]> {
        return apiService.searchBooks(query: query, sort: sort, page: page)
            .map { $0.documents } // 응답에서 documents 배열만 추출
    }
}

// 테스트나 개발 중에 사용하는 Mock 데이터 소스
class MockBookDataSource: BookDataSource {
    func fetchBooks(query: String, sort: String, page: Int) -> Observable<[BookItemModel]> {
        // 샘플 데이터 반환
        let sampleBooks: [BookItemModel] = [
            // 이 부분은 실제 BookItemModel에 맞게 채워야 합니다.
            // 현재 BookItemModel의 모든 프로퍼티를 만족하는 샘플 데이터를 생성하기는 어렵습니다.
            // 필요한 경우, 실제 API 응답을 기반으로 샘플 데이터를 만드세요.
        ]
        return Observable.just(sampleBooks).delay(.seconds(1), scheduler: MainScheduler.instance) // 실제 네트워크처럼 딜레이 추가
    }
}

// MARK: - Domain Layer (Repository Protocol)
protocol BookRepository {
    func fetchBooks(query: String, sort: String, page: Int) -> Observable<[BookItemModel]>
}

// MARK: - Data Layer (Repository Implementations)

// 실제 API를 사용하는 리포지토리
class RealBookRepository: BookRepository {
    private let dataSource: BookDataSource

    init(dataSource: BookDataSource) {
        self.dataSource = dataSource
    }

    func fetchBooks(query: String, sort: String, page: Int) -> Observable<[BookItemModel]> {
        return dataSource.fetchBooks(query: query, sort: sort, page: page)
    }
}

// Mock 데이터를 사용하는 리포지토리
class MockBookRepository: BookRepository {
    private let dataSource: BookDataSource

    init(dataSource: BookDataSource) {
        self.dataSource = dataSource
    }

    func fetchBooks(query: String, sort: String, page: Int) -> Observable<[BookItemModel]> {
        return dataSource.fetchBooks(query: query, sort: sort, page: page)
    }
}
