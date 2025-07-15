//
//  FavoritePersistenceRepository.swift
//  BookSearchApp
//
//  Created by 차상진 on 7/12/25.
//

import Foundation
import RxSwift

// MARK: - 즐겨찾기 책 데이터 처리를 위한 프로토콜
protocol FavoriteRepository {
    
    // 즐겨찾기 토글 실시간 감지 변수
    var favoriteBooksChanged: Observable<Void> { get }
    
    func saveFavoriteBook(book: BookItemModel) -> Observable<Void>
    func deleteFavoriteBook(isbn: String) -> Observable<Void>
    func isBookFavorite(isbn: String) -> Bool
    func hasFavoriteBooks() -> Bool
}
