//
//  LocalBookRepository.swift
//  BookSearchApp
//
//  Created by 차상진 on 7/12/25.
//

import Foundation
import RxSwift

class LocalBookFetchRepository: BookFetchRepository {
    private let coreDataManager: CoreDataManager

    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
    }

    func fetchBooks(query: String, sort: String, page: Int) -> Observable<BookSearchResponse> {
        print("LocalBookFetchRepository.fetchBooks() 호출됨")
        return coreDataManager.fetchFavoriteBooks()
            .map { books in
                var filteredBooks = books

                // 검색어 필터링
                if !query.isEmpty {
                    filteredBooks = filteredBooks.filter { $0.title.contains(query) || $0.authors.joined(separator: ", ").contains(query) }
                }

                // 정렬 (SortOption에 따라 추가 로직 필요)

                let meta = Meta(isEnd: true, pageableCount: filteredBooks.count, totalCount: filteredBooks.count)
                return BookSearchResponse(meta: meta, documents: filteredBooks)
            }
    }
    
}


