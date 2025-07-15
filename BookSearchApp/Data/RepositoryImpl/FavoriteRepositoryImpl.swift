//
//  FavoriteRepositoryImpl.swift
//  BookSearchApp
//
//  Created by 차상진 on 7/12/25.
//

import Foundation
import RxSwift

//MARK: - 즐겨찾기 관리 리포지토리 구현체
class FavoriteRepositoryImpl: FavoriteRepository {
    
    private let coreDataManager: CoreDataManager
    private let _favoriteBooksChanged = PublishSubject<Void>()

    var favoriteBooksChanged: Observable<Void> {
        return _favoriteBooksChanged.asObservable()
    }

    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
    }
    
    //MARK: - 도서를 즐겨찾기에 저장
    /// - Parameter book: 도서 모델
    /// - Returns: Observable<Void>
    func saveFavoriteBook(book: BookItemModel) -> Observable<Void> {
        print("FavoriteRepositoryImpl.saveFavoriteBook()")
        
        // `coreDataManager.saveFavoriteBook`으로 모델 전달
        return coreDataManager.saveFavoriteBook(book: book)
            .do(onNext: { [weak self] in
                self?._favoriteBooksChanged.onNext(())
            })
    }

    
    //MARK: - 도서를 즐겨찾기에서 삭제
    /// - Parameter isbn: 삭제 대상 도서 isbn
    /// - Returns: Observable<Void>
    func deleteFavoriteBook(isbn: String) -> Observable<Void> {
        return coreDataManager.deleteFavoriteBook(isbn: isbn)
            .do(onNext: { [weak self] in
                self?._favoriteBooksChanged.onNext(())
            })
    }
    
    //MARK: - 도서 isbn으로 즐겨찾기 유무 확인
    /// - Parameter isbn: 확인 대상 도서 isbn
    /// - Returns: 즐겨찾기 유무
    func isBookFavorite(isbn: String) -> Bool {
        return coreDataManager.isBookFavorite(isbn: isbn)
    }
    
    //MARK: - 즐겨찾기된 도서가 있는지 확인
    /// - Returns: 즐겨찾기된 도서가 하나라도 있으면 true, 없으면 false
    func hasFavoriteBooks() -> Bool {
        return coreDataManager.hasFavoriteBooks()
    }
}
