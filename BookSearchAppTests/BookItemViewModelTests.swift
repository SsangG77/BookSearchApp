//
//  BookItemViewModelTests.swift
//  BookSearchAppTests
//
//  Created by 차상진 on 7/14/25.
//

import XCTest
import RxSwift
import RxCocoa
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

    func testAddFavoriteBook() {
        // Given
        let book = BookItemModel(title: "Test Book", contents: "", url: nil, isbn: "123", authors: [], publisher: "", translators: [], price: 0, salePrice: 0, thumbnail: "", status: nil, datetime: nil)
        mockFavoriteRepository.isFavoriteResult = true // 즐겨찾기 상태를 true로 설정

        // When
        viewModel = BookItemViewModel(book: book, favoriteRepository: mockFavoriteRepository, deleteItem: { _ in })

        // Then
        XCTAssertTrue(viewModel.isFavorite)
        XCTAssertEqual(mockFavoriteRepository.favoriteBooks.count, 1)
        XCTAssertEqual(mockFavoriteRepository.favoriteBooks.first?.isbn, "123")
        
    
    }
}
