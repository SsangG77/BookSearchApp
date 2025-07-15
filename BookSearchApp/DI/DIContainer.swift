//
//  DIContainer.swift
//  BookSearchApp
//
//  Created by 차상진 on 7/10/25.
//

import Foundation


//MARK: - 앱의 의존성을 관리하고 주입하는 컨테이너
/// 각 계층(`Service`, `DataSource`, `Repository`, `UseCase`, `ViewModel`)에 필요한 인스턴스를 생성하고 제공
class DIContainer {
    static let shared = DIContainer()

    private let _favoriteRepository: FavoriteRepository

    private init() {
        _favoriteRepository = FavoriteRepositoryImpl(coreDataManager: CoreDataManager.shared)
    }
    
    // MARK: - Services
    /// API 통신을 위한 `APIService` 인스턴스
    private func makeAPIService() -> APIService {
        return APIService.shared
    }

    // MARK: - DataSources
    /// 도서 검색 API와 통신하는 `BookDataSource` 인스턴스
    private func makeBookDataSource() -> BookDataSource {
        return KakaoBookDataSource(apiService: makeAPIService())
    }

    // MARK: - Repositories
    /// API를 통해 도서 데이터를 가져오는 `BookFetchRepository` 인스턴스
    func makeAPIBookRepository() -> BookFetchRepository {
        return APIBookFetchRepository(dataSource: makeBookDataSource())
    }
    
    /// CoreData에서 도서 데이터를 가져오는 `BookFetchRepository` 인스턴스
    func makeLocalBookRepository() -> BookFetchRepository {
        return LocalBookFetchRepository(coreDataManager: CoreDataManager.shared)
    }
    
    /// 즐겨찾기 도서 데이터를 관리하는 `FavoriteRepository` 인스턴스
    func makeFavoriteRepository() -> FavoriteRepository {
        return _favoriteRepository
    }

    // MARK: - Use Cases
    /// API를 통한 도서 검색 로직이 있는 `BooksListUseCase` 인스턴스
    func makeSearchUseCase() -> BooksListUseCase {
        return APISearchUseCase(repository: makeAPIBookRepository())
    }

    /// 로컬 즐겨찾기 도서 목록 조회 및 필터링 로직이 있는 `BooksListUseCase` 인스턴스
    func makeFavoritesUseCase() -> BooksListUseCase {
        return LocalFavoritesUseCase(bookRepository: makeLocalBookRepository())
    }

    // MARK: - ViewModels
    /// 검색 화면에 필요한 `BooksListViewModel` 인스턴스를 제공
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

    /// 즐겨찾기 화면에 필요한 `BooksListViewModel` 인스턴스를 제공
    func makeFavoritesBooksListViewModel() -> BooksListViewModel {
        let availableSortOptions: [SortOption] = [.titleAsc, .titleDesc]
        return BooksListViewModel(
            useCase: makeFavoritesUseCase(),
            initialSortOption: .titleAsc,
            availableSortOptions: availableSortOptions,
            viewType: .favorite,
            favoriteRepository: makeFavoriteRepository()
        )
    }
}
