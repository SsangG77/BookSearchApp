//
//  MockDIContainer.swift
//  BookSearchAppTests
//
//  Created by 차상진 on 7/12/25.
//

import Foundation

//MARK: - MockDIContainer
//class MockDIContainer {
//
//    func makeDataSource() -> BookDataSource {
//        return MockBookDataSource()
//    }
//
//    func makeRepository() -> BookRepository {
//        return MockBookRepository(dataSource: makeDataSource())
//    }
//
//    func makeSearchUseCase() -> BooksListUseCase {
//        return APISearchUseCase(repository: makeRepository())
//    }
//
//    func makeSearchViewModel() -> BooksListViewModel {
//        let availableSortOptions: [SortOption] = [.accuracy, .latest]
//        return BooksListViewModel(
//            useCase: makeSearchUseCase(),
//            initialSortOption: .accuracy,
//            availableSortOptions: availableSortOptions
//        )
//    }
//}
