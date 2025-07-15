//
//  LocalBookRepository.swift
//  BookSearchApp
//
//  Created by 차상진 on 7/12/25.
//

import Foundation
import RxSwift

//MARK: - 즐겨찾기 데이터 가져오는 리포지토리 구현체
class LocalBookFetchRepository: BookFetchRepository {
    private let coreDataManager: CoreDataManager

    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
    }

    
    //MARK: - coreData의 즐찾기에서 데이터 로드
    /// - Parameters:
    ///   - query: 검색어
    ///   - sort: 정렬 옵션 (여기서는 사용하지 않음)
    ///   - page:즐겨찾기는 page사용하지 않음
    /// - Returns: 데이터 목록 Observable로 감싸서 반환
    func fetchBooks(query: String, sort: String, page: Int) -> Observable<BookSearchResponse> {
        print("LocalBookFetchRepository.fetchBooks() 호출됨")
        return coreDataManager.fetchFavoriteBooks()
            .map { books in
                var filteredBooks = books

                // 검색어 필터링
                if !query.isEmpty {
                    filteredBooks = filteredBooks.filter { $0.title.contains(query) || $0.authors.joined(separator: ", ").contains(query) }
                }

                // 즐겨찾기용 meta
                let meta = Meta(isEnd: true, pageableCount: filteredBooks.count, totalCount: filteredBooks.count)
                return BookSearchResponse(meta: meta, documents: filteredBooks)
            }
    }
    
}


