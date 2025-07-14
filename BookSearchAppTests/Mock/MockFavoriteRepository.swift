//
//  MockFavoriteRepository.swift
//  BookSearchAppTests
//
//  Created by 차상진 on 7/14/25.
//

import Foundation
import RxSwift
@testable import BookSearchApp

class MockFavoriteRepository: FavoriteRepository {
    var savedBook: BookItemModel? = nil
    var deletedIsbn: String? = nil
    var isFavoriteResult: Bool = false // 이 값을 사용하도록 수정
    var favoriteBooks: [BookItemModel] = []
    
    private let _favoriteBooksChanged = PublishSubject<Void>()

    var favoriteBooksChanged: Observable<Void> {
        return _favoriteBooksChanged.asObservable()
    }

    func saveFavoriteBook(book: BookItemModel) -> Observable<Void> {
        savedBook = book
        favoriteBooks.append(book)
        _favoriteBooksChanged.onNext(()) // 변경 이벤트 발생
        return .empty()
    }

    func deleteFavoriteBook(isbn: String) -> Observable<Void> {
        deletedIsbn = isbn
        favoriteBooks.removeAll { $0.isbn == isbn }
        _favoriteBooksChanged.onNext(()) // 변경 이벤트 발생
        return .empty()
    }

    func isBookFavorite(isbn: String) -> Bool {
        return isFavoriteResult // isFavoriteResult 값을 반환하도록 수정
    }
    
//    func fetchFavoriteBooks() -> Single<[BookItemModel]> {
//        return .just(favoriteBooks)
//    }
}
