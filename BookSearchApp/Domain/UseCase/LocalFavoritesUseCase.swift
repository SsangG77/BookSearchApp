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
    private let bookRepository: BookFetchRepository // `LocalBookRepository` 가 주입됨

    init(bookRepository: BookFetchRepository) {
        self.bookRepository = bookRepository
    }
    
    //MARK: - 즐겨찾기 도서 목록 가져오기
    /// - Parameters:
    ///   - query: 검색어
    ///   - sort: 정렬 옵션
    ///   - page: 즐겨찾기 목록 조회는 기본값 = 1
    ///   - minPrice: 최소 금액 필터
    ///   - maxPrice: 최대 금액 필터
    /// - Returns: Observable<BookSearchResponse>
    func execute(query: String, sort: SortOption, page: Int, minPrice: String, maxPrice: String) -> Observable<BookSearchResponse> {
        return bookRepository.fetchBooks(query: query, sort: sort.queryValue, page: page)
            .do(onError: { error in
                print("LocalFavoritesUseCase.execute() 에러: \(error)")
            })
            .map { response in
                print("LocalFavoritesUseCase.execute() map")
                
                // 전체 도서
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
