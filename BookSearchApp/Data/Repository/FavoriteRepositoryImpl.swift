//
//  FavoriteRepositoryImpl.swift
//  BookSearchApp
//
//  Created by 차상진 on 7/12/25.
//

import Foundation
import RxSwift

class FavoriteRepositoryImpl: FavoriteRepository {
    
    private let coreDataManager: CoreDataManager
    private let _favoriteBooksChanged = PublishSubject<Void>()

    var favoriteBooksChanged: Observable<Void> {
        return _favoriteBooksChanged.asObservable()
    }

    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
    }
    
    func saveFavoriteBook(book: BookItemModel) -> Observable<Void> {
        print("FavoriteRepositoryImpl.saveFavoriteBook()")
        return coreDataManager.saveFavoriteBook(book: book)
            .do(onNext: { [weak self] in
                self?._favoriteBooksChanged.onNext(())
            })
    }

    func deleteFavoriteBook(isbn: String) -> Observable<Void> {
        return coreDataManager.deleteFavoriteBook(isbn: isbn)
            .do(onNext: { [weak self] in
                self?._favoriteBooksChanged.onNext(())
            })
    }
    
    func isBookFavorite(isbn: String) -> Bool {
        return coreDataManager.isBookFavorite(isbn: isbn)
    }
}