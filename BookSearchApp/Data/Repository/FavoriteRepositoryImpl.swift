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

    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
    }
    
    func saveFavoriteBook(book: BookItemModel) -> Observable<Void> {
        print("FavoriteRepositoryImpl.saveFavoriteBook()")
        return coreDataManager.saveFavoriteBook(book: book)
    }

    func deleteFavoriteBook(isbn: String) -> Observable<Void> {
        return coreDataManager.deleteFavoriteBook(isbn: isbn)
    }
    
    func isBookFavorite(isbn: String) -> Bool {
        return coreDataManager.isBookFavorite(isbn: isbn)
    }
}
