//
//  BookItemViewModel.swift
//  BookSearchApp
//
//  Created by 차상진 on 7/10/25.
//

import Foundation
import RxSwift // RxSwift 추가

// MARK: - Presentation Layer (ViewModel)
class BookItemViewModel: ObservableObject { // struct -> class, ObservableObject 채택
    private let disposeBag = DisposeBag()
    private let book: BookItemModel
    private let favoriteRepository: FavoriteRepository // FavoriteRepository 주입
    
    @Published var isFavorite: Bool = false // 즐겨찾기 상태

    init(book: BookItemModel, favoriteRepository: FavoriteRepository) {
        self.book = book
        self.favoriteRepository = favoriteRepository
        checkFavoriteStatus()
    }
    
    var id: String {
        book.id.uuidString
    }

    var title: String {
        book.title
    }

    var authorsText: String {
        book.authors.joined(separator: ", ")
    }

    var coverURL: URL? {
        guard let thumbnail = book.thumbnail else { return nil }
        return URL(string: thumbnail)
    }

    var publisher: String {
        book.publisher ?? "정보 없음"
    }

    var originalPrice: Int {
        book.price ?? 0
    }

    var salePrice: Int {
        book.salePrice ?? 0
    }

    var isDiscounted: Bool {
        guard let price = book.price, let salePrice = book.salePrice else { return false }
        return salePrice < price
    }
    
    var status: String {
        book.status ?? "정보 없음"
    }

    var discountPercentage: String {
        guard isDiscounted, let price = book.price, let salePrice = book.salePrice, price > 0 else { return "" }
        let percentage = (Double(price - salePrice) / Double(price)) * 100
        return String(format: "%.0f", percentage)
    }
    
    var publishedDateText: String {
        guard let date = book.datetime else { return "날짜 정보 없음" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        return dateFormatter.string(from: date)
    }
    
    // 즐겨찾기 상태 확인
    private func checkFavoriteStatus() {
        self.isFavorite = favoriteRepository.isBookFavorite(isbn: book.isbn)
    }
    
    // 즐겨찾기 토글
    func toggleFavorite() {
        print("BookItemViewModel.toggleFavorite()", book.title)
        if isFavorite {
            favoriteRepository.deleteFavoriteBook(isbn: book.isbn)
                .subscribe(onCompleted: { [weak self] in
                    self?.isFavorite = false
                })
                .disposed(by: disposeBag)
        } else {
            favoriteRepository.saveFavoriteBook(book: book)
                .subscribe(onCompleted: { [weak self] in
                    self?.isFavorite = true
                })
                .disposed(by: disposeBag)
        }
    }
}

