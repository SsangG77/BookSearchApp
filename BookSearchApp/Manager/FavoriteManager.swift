//
//  FavoriteManager.swift
//  BookSearchApp
//
//  Created by 차상진 on 7/11/25.
//

import Foundation

/// 즐겨찾기 관리 매니저 (싱글톤)
class FavoriteManager: ObservableObject {
    static let shared = FavoriteManager()
    @Published var favoriteBooks: [BookItemModel] = []

    private init() {}

    func addFavorite(book: BookItemModel) {
        if !favoriteBooks.contains(where: { $0.id == book.id }) {
            favoriteBooks.append(book)
        }
    }

    func removeFavorite(book: BookItemModel) {
        favoriteBooks.removeAll { $0.id == book.id }
    }

    func isFavorite(book: BookItemModel) -> Bool {
        favoriteBooks.contains { $0.id == book.id }
    }
}
