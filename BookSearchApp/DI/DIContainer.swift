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
    
    
    //MARK: - DataSources
    

    // MARK: - Repositories
    func makeBookRepository() -> BookRepository {
        // 실제 앱에서는 여기에 APIClient 등을 주입받아 RealBookRepository를 생성합니다.
        // 현재는 MockBookDataSource를 사용하여 MockBookRepository를 반환합니다.
        let dataSource = MockBookDataSource()
        return MockBookRepository(dataSource: dataSource)
    }

    // MARK: - Use Cases
    func makeFetchBooksUseCase() -> FetchBooksUseCase {
        return FetchBooksUseCaseImpl(repository: makeBookRepository())
    }
    
    func makeBooksListViewModel() -> BooksListViewModel {
        return BooksListViewModel(fetchBooksUseCase: makeFetchBooksUseCase())
    }
}
