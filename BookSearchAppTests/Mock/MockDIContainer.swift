//
//  MockDIContainer.swift
//  BookSearchAppTests
//
//  Created by 차상진 on 7/14/25.
//

import Foundation
@testable import BookSearchApp

class MockDIContainer {
    static let shared = MockDIContainer()
    
    func makeFavoriteRepository() -> FavoriteRepository {
        return MockFavoriteRepository()
    }
    
    func makeMockDataSource() -> BookDataSource {
        return MockBookDataSource()
    }
    
    func makeMockRepository() -> BookFetchRepository {
        return MockBookRepository(dataSource: makeMockDataSource())
    }
    
    func makeMockUseCase() -> BooksListUseCase {
        return MockUseCase(repository: makeMockRepository())
    }
    
    func makeMockViewModel() -> BooksListViewModel {
        let availableSortOptions: [SortOption] = [.accuracy, .latest]
        return BooksListViewModel(
            useCase: makeMockUseCase() ,
            initialSortOption: .accuracy,
            availableSortOptions: availableSortOptions,
            viewType: .search,
            favoriteRepository: makeFavoriteRepository()
        )
    }
}
