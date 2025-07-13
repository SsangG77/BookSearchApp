//
//  BookItemViewModel.swift
//  BookSearchApp
//
//  Created by 차상진 on 7/10/25.
//

import Foundation
import RxSwift // RxSwift 추가

// MARK: - Presentation Layer (ViewModel)
class BookItemViewModel: ObservableObject, Identifiable {
    private let disposeBag = DisposeBag()
    @Published var book: BookItemModel // 책 모델
    private let favoriteRepository: FavoriteRepository // 즐겨찾기 책 데이터 처리 객체 주입
    
    @Published var isFavorite: Bool = false // 즐겨찾기 상태
    
    var deleteItem: (_ isbn: String) -> Void

    init(
        book: BookItemModel,
        favoriteRepository: FavoriteRepository,
        deleteItem: @escaping (_ isbn: String) -> Void
    ) {
        self.book = book
        self.favoriteRepository = favoriteRepository
        self.deleteItem = deleteItem
        checkFavoriteStatus()
    }
    
    var id: String {
        book.id.uuidString
    }
    
    var isbn: String {
        book.isbn
    }

    var title: String {
        book.title
    }

    var authorsText: String {
        book.authors.joined(separator: ", ")
    }
    
    var translatorsText: String {
        book.translators.joined(separator: ", ")
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
    
    var searchURL: String {
        book.url ?? ""
    }
    
    var contents: String {
        book.contents ?? "내용 없음"
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
    
    var koreanFormattedPublishedDate: String {
        guard let date = book.datetime else { return "날짜 정보 없음" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
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
            deleteItem(book.isbn)
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