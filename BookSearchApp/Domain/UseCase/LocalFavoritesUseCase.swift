//
//  LocalFavoritesUseCase.swift
//  BookSearchApp
//
//  Created by 차상진 on 7/11/25.
//

import Foundation
import RxSwift

// MARK: - 즐겨찾기 UseCase 프로토콜 구현체
class LocalFavoritesUseCase: BooksListUseCase {
    private let bookRepository: BookFetchRepository // LocalBookRepository가 주입됨

    init(bookRepository: BookFetchRepository) {
        self.bookRepository = bookRepository
    }
    
    func execute(query: String, sort: SortOption, page: Int, minPrice: String, maxPrice: String) -> Observable<BookSearchResponse> {
        return bookRepository.fetchBooks(query: query, sort: sort.queryValue, page: page)
            .do(onError: { error in
                print("LocalFavoritesUseCase fetchBooks Error: \(error)")
            })
            .map { response in
                print("LocalFavoritesUseCase.execute() map - documents count: \(response.documents.count)")
                print("LocalFavoritesUseCase.execute() map")
                var books = response.documents

                // 검색어 필터링
                if !query.isEmpty {
                    books = books.filter { $0.title.contains(query) || $0.authors.joined(separator: ", ").contains(query) }
                }

                // 금액 필터링
                if minPrice != "" || maxPrice != "" {                
                    books = books.filter { ($0.price ?? 0) >= Int(minPrice) ?? 0 }
                    books = books.filter { ($0.price ?? 0) <= Int(maxPrice) ?? 0 }
                }
                

                // 정렬
                switch sort {
                case .titleAsc:
                    books.sort { $0.title < $1.title }
                case .titleDesc:
                    books.sort { $0.title > $1.title }
                default:
                    break
                }
                
                // 로컬 데이터는 isEnd가 항상 true라고 가정
                let meta = Meta(isEnd: true, pageableCount: books.count, totalCount: books.count)
                return BookSearchResponse(meta: meta, documents: books)
            }
    }
}
