//
//  BooksListViewModelTests.swift
//  BookSearchAppTests
//
//  Created by 차상진 on 7/14/25.
//

import XCTest
import RxSwift
import RxCocoa
import RxCombine
@testable import BookSearchApp

extension XCTestCase {
    func date(from iso8601String: String) -> Date? {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.date(from: iso8601String)
    }
}

class BooksListViewModelTests: XCTestCase {
    
    var viewModel: BooksListViewModel!
    var mockUseCase: MockUseCase! // Mock UseCase
    var mockFavoriteRepository: MockFavoriteRepository! // Mock FavoriteRepository
    var disposeBag: DisposeBag!
    
    
    override func setUpWithError() throws {
        // 객체 초기화
        mockUseCase = MockUseCase(repository: MockBookRepository(dataSource: MockBookDataSource()))
        mockFavoriteRepository = MockFavoriteRepository()
        
        viewModel = BooksListViewModel(
            useCase: mockUseCase,
            initialSortOption: .accuracy,
            availableSortOptions: [.accuracy, .latest],
            viewType: .search,
            favoriteRepository: mockFavoriteRepository
        )
        disposeBag = DisposeBag()
    }
    
    
    override func tearDownWithError() throws {
        // 리소스 해제
        viewModel = nil
        mockUseCase = nil
        mockFavoriteRepository = nil
        disposeBag = nil
    }
    
    // MARK: - 테스트 케이스
    
    // 실제 API 호출하여 데이터 로드 되는지 테스트
    func testRealAPIDataLoading() {
        
        let expectation = XCTestExpectation(description: "kakao API")
        
        // Given
        // 리스트 뷰모델 초기화
        viewModel = DIContainer.shared.makeSearchBooksListViewModel()
        
        // When
        // 실제 검색어를 사용하여 API 호출
        viewModel.loadBooks(searchText: "코딩")
        
        // Then
        // 응답된 데이터로 테스트
        viewModel.$allLoadedBookViewModels
            .asObservable()
            .skip(1) // 첫 빈 배열 스킵
            .subscribe(onNext: { viewModels in
                XCTAssertFalse(viewModels.isEmpty, "조회된 결과가 비어있는지 확인")
                
                // 첫번째 책 제목이 비어있는지 확인
                XCTAssertFalse(viewModels.first?.book.title.isEmpty ?? true, "첵제목 있음")
                
                // 조회된 데이터 갯수가 20개인지 확인
                XCTAssertEqual(viewModels.count, 20, "20개 데이터 조회됨")
                
                expectation.fulfill()
            }, onError: { error in
                XCTFail("API 에러 발생: \(error)")
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 10.0) // 네트워크 지연을 고려하여 10초 설정
    }
    
    // 즐겨찾기 저장 테스트
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
