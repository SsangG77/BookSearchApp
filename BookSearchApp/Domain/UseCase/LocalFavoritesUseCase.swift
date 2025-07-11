//
//  LocalFavoritesUseCase.swift
//  BookSearchApp
//
//  Created by 차상진 on 7/11/25.
//

import Foundation
import RxSwift

class LocalFavoritesUseCase: BooksListUseCase {
    func execute(query: String, sort: SortOption, page: Int) -> Observable<[BookItemModel]> {
        var books = FavoriteManager.shared.favoriteBooks

        // 검색어 필터링
        if !query.isEmpty {
            books = books.filter { $0.title.contains(query) }
        }

        // 정렬
        switch sort {
        case .titleAsc:
            books.sort { $0.title < $1.title }
        case .titleDesc:
            books.sort { $0.title > $1.title }
        case .priceFilter: // 예시: 15000원 이상 필터링
            books = books.filter { $0.price >= 15000 }
        default:
            break // API용 정렬은 여기서 처리하지 않음
        }
        
        return .just(books)
    }
}
