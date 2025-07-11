//
//  DIContainer.swift
//  BookSearchApp
//
//  Created by 차상진 on 7/10/25.
//

import Foundation

class DIContainer {
    static let shared = DIContainer()

    private init() {}
    
    // MARK: - Services
    private func makeAPIService() -> APIService {
        return APIService.shared
    }

    // MARK: - DataSources
    private func makeBookDataSource() -> BookDataSource {
        return KakaoBookDataSource(apiService: makeAPIService())
    }

    // MARK: - Repositories
    func makeBookRepository() -> BookRepository {
        return RealBookRepository(dataSource: makeBookDataSource())
    }

    // MARK: - Use Cases
    func makeSearchUseCase() -> BooksListUseCase {
        return APISearchUseCase(repository: makeBookRepository())
    }

    func makeFavoritesUseCase() -> BooksListUseCase {
        return LocalFavoritesUseCase()
    }

    // MARK: - ViewModels
    func makeSearchBooksListViewModel() -> BooksListViewModel {
        let availableSortOptions: [SortOption] = [.accuracy, .latest]
        return BooksListViewModel(
            useCase: makeSearchUseCase(),
            initialSortOption: .accuracy,
            availableSortOptions: availableSortOptions
        )
    }

    func makeFavoritesBooksListViewModel() -> BooksListViewModel {
        let availableSortOptions: [SortOption] = [.titleAsc, .titleDesc, .priceFilter]
        return BooksListViewModel(
            useCase: makeFavoritesUseCase(),
            initialSortOption: .titleAsc,
            availableSortOptions: availableSortOptions
        )
    }
}

//MARK: - MockDIContainer
class MockDIContainer {
    
    func makeDataSource() -> BookDataSource {
        return MockBookDataSource()
    }
    
    func makeRepository() -> BookRepository {
        return MockBookRepository(dataSource: makeDataSource())
    }
    
    func makeSearchUseCase() -> BooksListUseCase {
        return APISearchUseCase(repository: makeRepository())
    }
    
    func makeSearchViewModel() -> BooksListViewModel {
        let availableSortOptions: [SortOption] = [.accuracy, .latest]
        return BooksListViewModel(
            useCase: makeSearchUseCase(),
            initialSortOption: .accuracy,
            availableSortOptions: availableSortOptions
        )
    }
}
