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
    func fetchBooks(page: Int) -> Observable<[BookItemModel]>
}

// MARK: - Data Layer (DataSource Implementation - Mock)
class MockBookDataSource: BookDataSource {
    func fetchBooks(page: Int) -> Observable<[BookItemModel]> {
        // 실제 API 호출 대신 샘플 데이터를 반환합니다.
        // 페이지에 따라 다른 샘플 데이터를 반환하도록 수정
        let allSampleBooks = [
            BookItemModel(
                isbn: "8996991341 9788996991342",
                coverURL: "https://search1.kakaocdn.net/thumb/R120x174.q85/?fname=http%3A%2F%2Ft1.daumcdn.net%2Flbook%2Fimage%2F1467038",
                title: "미움받을 용기",
                authors: ["기시미 이치로", "고가 후미타케"],
                publisher: "인플루엔셜",
                date: Date(timeIntervalSinceReferenceDate: 1416153600),
                status: "정상",
                price: 19000,
                salePrice: 12000
            ),
            BookItemModel(
                isbn: "978893291724",
                coverURL: "https://search1.kakaocdn.net/thumb/R120x174.q85/?fname=http%3A%2F%2Ft1.daumcdn.net%2Flbook%2Fimage%2F1467038",
                title: "어린 왕자",
                authors: ["앙투안 드 생텍쥐페리"],
                publisher: "문학동네",
                date: Date(timeIntervalSinceReferenceDate: 1416153600),
                status: "정상",
                price: 10000,
                salePrice: 10000
            ),
            BookItemModel(
                isbn: "978893291725",
                coverURL: "https://search1.kakaocdn.net/thumb/R120x174.q85/?fname=http%3A%2F%2Ft1.daumcdn.net%2Flbook%2Fimage%2F1467038",
                title: "데미안",
                authors: ["헤르만 헤세"],
                publisher: "민음사",
                date: Date(timeIntervalSinceReferenceDate: 1416153600),
                status: "절판",
                price: 15000,
                salePrice: 15000
            ),
            BookItemModel(
                isbn: "8996991341 9788996991342-2",
                coverURL: "https://search1.kakaocdn.net/thumb/R120x174.q85/?fname=http%3A%2F%2Ft1.daumcdn.net%2Flbook%2Fimage%2F1467038",
                title: "미움받을 용기 2",
                authors: ["기시미 이치로", "고가 후미타케"],
                publisher: "인플루엔셜",
                date: Date(timeIntervalSinceReferenceDate: 1416153600),
                status: "정상",
                price: 20000,
                salePrice: 15000
            ),
            BookItemModel(
                isbn: "978893291724-2",
                coverURL: "https://search1.kakaocdn.net/thumb/R120x174.q85/?fname=http%3A%2F%2Ft1.daumcdn.net%2Flbook%2Fimage%2F1467038",
                title: "어린 왕자 2",
                authors: ["앙투안 드 생텍쥐페리"],
                publisher: "문학동네",
                date: Date(timeIntervalSinceReferenceDate: 1416153600),
                status: "정상",
                price: 11000,
                salePrice: 11000
            ),
            BookItemModel(
                isbn: "978893291725-2",
                coverURL: "https://search1.kakaocdn.net/thumb/R120x174.q85/?fname=http%3A%2F%2Ft1.daumcdn.net%2Flbook%2Fimage%2F1467038",
                title: "데미안 2",
                authors: ["헤르만 헤세"],
                publisher: "민음사",
                date: Date(timeIntervalSinceReferenceDate: 1416153600),
                status: "절판",
                price: 16000,
                salePrice: 16000
            )
        ]

        let pageSize = 3 // 한 페이지당 3개씩 반환
        let startIndex = (page - 1) * pageSize
        let endIndex = min(startIndex + pageSize, allSampleBooks.count)

        guard startIndex < allSampleBooks.count else {
            return Observable.just([]) // 더 이상 데이터가 없음
        }

        let paginatedBooks = Array(allSampleBooks[startIndex..<endIndex])
        return Observable.just(paginatedBooks)
    }
}

// MARK: - Domain Layer (Repository Protocol)
protocol BookRepository {
    func fetchBooks(page: Int) -> Observable<[BookItemModel]>
}

// MARK: - Data Layer (Repository Implementation - Mock)
class MockBookRepository: BookRepository {
    private let dataSource: BookDataSource

    init(dataSource: BookDataSource) {
        self.dataSource = dataSource
    }

    func fetchBooks(page: Int) -> Observable<[BookItemModel]> {
        return dataSource.fetchBooks(page: page)
    }
}
