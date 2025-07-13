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
    func makeAPIBookRepository() -> BookFetchRepository {
        return APIBookFetchRepository(dataSource: makeBookDataSource())
    }
    
    func makeLocalBookRepository() -> BookFetchRepository {
        return LocalBookFetchRepository(coreDataManager: CoreDataManager.shared)
    }
    
    func makeFavoriteRepository() -> FavoriteRepository {
        return FavoriteRepositoryImpl(coreDataManager: CoreDataManager.shared)
    }

    // MARK: - Use Cases
    func makeSearchUseCase() -> BooksListUseCase {
        return APISearchUseCase(repository: makeAPIBookRepository())
    }

    func makeFavoritesUseCase() -> BooksListUseCase {
        return LocalFavoritesUseCase(bookRepository: makeLocalBookRepository())
    }

    // MARK: - ViewModels
    func makeSearchBooksListViewModel() -> BooksListViewModel {
        let availableSortOptions: [SortOption] = [.accuracy, .latest]
        return BooksListViewModel(
            useCase: makeSearchUseCase(),
            initialSortOption: .accuracy,
            availableSortOptions: availableSortOptions,
            viewType: .search,
            favoriteRepository: makeFavoriteRepository()
        )
    }

    func makeFavoritesBooksListViewModel() -> BooksListViewModel {
        let availableSortOptions: [SortOption] = [.titleAsc, .titleDesc, .priceFilter]
        return BooksListViewModel(
            useCase: makeFavoritesUseCase(),
            initialSortOption: .titleAsc,
            availableSortOptions: availableSortOptions,
            viewType: .favorite,
            favoriteRepository: makeFavoriteRepository()
        )
    }
}