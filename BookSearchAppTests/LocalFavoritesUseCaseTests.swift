
//
//  LocalFavoritesUseCaseTests.swift
//  BookSearchAppTests
//
//  Created by 차상진 on 7/15/25.
//

import XCTest
import RxSwift
@testable import BookSearchApp

class LocalFavoritesUseCaseTests: XCTestCase {

    var useCase: LocalFavoritesUseCase!
    var mockRepository: MockBookFetchRepository!
    var disposeBag: DisposeBag!

    override func setUpWithError() throws {
        mockRepository = MockBookFetchRepository()
        useCase = LocalFavoritesUseCase(bookRepository: mockRepository)
        disposeBag = DisposeBag()
    }

    override func tearDownWithError() throws {
        useCase = nil
        mockRepository = nil
        disposeBag = nil
    }

    // MARK: - Test Cases

    func testExecuteNoFilterNoSort() {
        // Given
        let expectation = XCTestExpectation(description: "필터 및 정렬 없음으로 실행")
        let mockBooks = [
            BookItemModel(id: UUID(), title: "세번째 책", contents: "Content C", url: nil, isbn: "3", authors: ["작가 C"], publisher: "출판사 C", translators: [], price: 3000, salePrice: 2500, thumbnail: nil, status: nil, datetime: nil),
            BookItemModel(id: UUID(), title: "첫번째 책", contents: "Content A", url: nil, isbn: "1", authors: ["작가 A"], publisher: "출판사 A", translators: [], price: 1000, salePrice: 800, thumbnail: nil, status: nil, datetime: nil),
            BookItemModel(id: UUID(), title: "두번째 책", contents: "Content B", url: nil, isbn: "2", authors: ["작가 B"], publisher: "출판사 B", translators: [], price: 2000, salePrice: 1800, thumbnail: nil, status: nil, datetime: nil)
        ]
        let mockResponse = BookSearchResponse(meta: Meta(isEnd: true, pageableCount: mockBooks.count, totalCount: mockBooks.count), documents: mockBooks)
        mockRepository.fetchBooksResult = Observable.just(mockResponse)

        // When
        useCase.execute(query: "", sort: .accuracy, page: 1, minPrice: "", maxPrice: "")
            .subscribe(onNext: { response in
                // Then
                XCTAssertEqual(response.documents.count, 3)
                XCTAssertEqual(response.documents[0].title, "세번째 책")
                XCTAssertEqual(response.documents[1].title, "첫번째 책")
                XCTAssertEqual(response.documents[2].title, "두번째 책")
                expectation.fulfill()
            }, onError: { error in
                XCTFail("Error: \(error)")
                expectation.fulfill()
            })
            .disposed(by: disposeBag)

        wait(for: [expectation], timeout: 1.0)
    }

    func testExecuteQueryFilter() {
        // Given
        let expectation = XCTestExpectation(description: "쿼리 필터로 실행")
        let mockBooks = [
            BookItemModel(id: UUID(), title: "Swift 기초 다지기", contents: "Swift 기초 다지기", url: nil, isbn: "1", authors: ["작가 A"], publisher: "출판사", translators: [], price: 1000, salePrice: 800, thumbnail: nil, status: nil, datetime: nil),
            BookItemModel(id: UUID(), title: "Python 입문", contents: "Python 입문", url: nil, isbn: "2", authors: ["작가 B"], publisher: "출판사", translators: [], price: 2000, salePrice: 1800, thumbnail: nil, status: nil, datetime: nil),
            BookItemModel(id: UUID(), title: "Swift 정복", contents: "Swift 정복", url: nil, isbn: "3", authors: ["작가 A"], publisher: "출판사", translators: [], price: 3000, salePrice: 2500, thumbnail: nil, status: nil, datetime: nil)
        ]
        let mockResponse = BookSearchResponse(meta: Meta(isEnd: true, pageableCount: mockBooks.count, totalCount: mockBooks.count), documents: mockBooks)
        mockRepository.fetchBooksResult = Observable.just(mockResponse)

        // When
        useCase.execute(query: "Swift", sort: .accuracy, page: 1, minPrice: "", maxPrice: "")
            .subscribe(onNext: { response in
                // Then
                XCTAssertEqual(response.documents.count, 2)
                XCTAssertTrue(response.documents.contains(where: { $0.title == "Swift 기초 다지기" }))
                XCTAssertTrue(response.documents.contains(where: { $0.title == "Swift 정복" }))
                expectation.fulfill()
            }, onError: { error in
                XCTFail("Error: \(error)")
                expectation.fulfill()
            })
            .disposed(by: disposeBag)

        wait(for: [expectation], timeout: 1.0)
    }

    func testExecutePriceFilter() {
        // Given
        let expectation = XCTestExpectation(description: "가격 필터로 실행")
        let mockBooks = [
            BookItemModel(id: UUID(), title: "Swift 기초 다지기", contents: "Swift 기초 다지기", url: nil, isbn: "1", authors: ["작가 A"], publisher: "출판사", translators: [], price: 1500, salePrice: 800, thumbnail: nil, status: nil, datetime: nil),
            BookItemModel(id: UUID(), title: "Python 입문", contents: "Python 입문", url: nil, isbn: "2", authors: ["작가 B"], publisher: "출판사", translators: [], price: 2000, salePrice: 1800, thumbnail: nil, status: nil, datetime: nil),
            BookItemModel(id: UUID(), title: "Swift 정복", contents: "Swift 정복", url: nil, isbn: "3", authors: ["작가 A"], publisher: "출판사", translators: [], price: 3000, salePrice: 2500, thumbnail: nil, status: nil, datetime: nil)
        ]
        let mockResponse = BookSearchResponse(meta: Meta(isEnd: true, pageableCount: mockBooks.count, totalCount: mockBooks.count), documents: mockBooks)
        mockRepository.fetchBooksResult = Observable.just(mockResponse)

        // When
        useCase.execute(query: "", sort: .accuracy, page: 1, minPrice: "1000", maxPrice: "2500")
            .subscribe(onNext: { response in
                // Then
                XCTAssertEqual(response.documents.count, 2)
                XCTAssertEqual(response.documents.first?.title, "Swift 기초 다지기")
                expectation.fulfill()
            }, onError: { error in
                XCTFail("Error: \(error)")
                expectation.fulfill()
            })
            .disposed(by: disposeBag)

        wait(for: [expectation], timeout: 1.0)
    }

    func testExecuteSortTitleAsc() {
        // Given
        let expectation = XCTestExpectation(description: "제목 오름차순 정렬로 실행")
        let mockBooks = [
            BookItemModel(id: UUID(), title: "Book C", contents: "Content C", url: nil, isbn: "3", authors: ["작가 A"], publisher: "출판사", translators: [], price: 3000, salePrice: 2500, thumbnail: nil, status: nil, datetime: nil),
            BookItemModel(id: UUID(), title: "Book A", contents: "Content A", url: nil, isbn: "1", authors: ["작가 A"], publisher: "출판사", translators: [], price: 1000, salePrice: 800, thumbnail: nil, status: nil, datetime: nil),
            BookItemModel(id: UUID(), title: "Book B", contents: "Content B", url: nil, isbn: "2", authors: ["작가 B"], publisher: "출판사", translators: [], price: 2000, salePrice: 1800, thumbnail: nil, status: nil, datetime: nil)
        ]
        let mockResponse = BookSearchResponse(meta: Meta(isEnd: true, pageableCount: mockBooks.count, totalCount: mockBooks.count), documents: mockBooks)
        mockRepository.fetchBooksResult = Observable.just(mockResponse)

        // When
        useCase.execute(query: "", sort: .titleAsc, page: 1, minPrice: "", maxPrice: "")
            .subscribe(onNext: { response in
                // Then
                XCTAssertEqual(response.documents.count, 3)
                XCTAssertEqual(response.documents[0].title, "Book A")
                XCTAssertEqual(response.documents[1].title, "Book B")
                XCTAssertEqual(response.documents[2].title, "Book C")
                expectation.fulfill()
            }, onError: { error in
                XCTFail("Error: \(error)")
                expectation.fulfill()
            })
            .disposed(by: disposeBag)

        wait(for: [expectation], timeout: 1.0)
    }
}
