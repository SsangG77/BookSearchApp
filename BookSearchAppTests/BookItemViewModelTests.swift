//
//  BookItemViewModelTests.swift
//  BookSearchAppTests
//
//  Created by 차상진 on 7/14/25.
//

import XCTest
import RxSwift
@testable import BookSearchApp

class BookItemViewModelTests: XCTestCase {

    var viewModel: BookItemViewModel!
    var mockFavoriteRepository: MockFavoriteRepository!
    var disposeBag: DisposeBag!

    override func setUpWithError() throws {
        mockFavoriteRepository = MockFavoriteRepository()
        disposeBag = DisposeBag()
    }

    override func tearDownWithError() throws {
        viewModel = nil
        mockFavoriteRepository = nil
        disposeBag = nil
    }

    // 즐겨찾기 버튼 테스트
    func testAddFavoriteBook() {
        
        // Given
        let testBook = BookItemModel(
            id: UUID(), // id 추가
            title: "Test Book",
            contents: "Test Contents",
            url: "http://test.com",
            isbn: "1234567890",
            authors: ["Test Author"],
            publisher: "Test Publisher",
            translators: [],
            price: 10000,
            salePrice: 9000,
            thumbnail: "http://test.com/thumbnail.jpg",
            status: "정상",
            datetime: Date()
        )

        // BookItemViewModel을 생성
        let bookItemViewModel = BookItemViewModel(
            book: testBook,
            favoriteRepository: mockFavoriteRepository,
            deleteItem: { _ in }
        )
        
        // When
        bookItemViewModel.toggleFavorite() // 즐겨찾기 추가

        // Then
        // mockFavoriteRepository의 savedBook이 설정되었는지 확인
        XCTAssertNotNil(mockFavoriteRepository.savedBook, "saveFavoriteBook 호출 확인")
        XCTAssertEqual(mockFavoriteRepository.savedBook?.isbn, testBook.isbn, "isbn 일치 확인")
        XCTAssertTrue(bookItemViewModel.isFavorite, "isFavorite == true 확인")
    }
}
