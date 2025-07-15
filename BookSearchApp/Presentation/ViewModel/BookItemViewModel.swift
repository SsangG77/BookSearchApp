//
//  BookItemViewModel.swift
//  BookSearchApp
//
//  Created by 차상진 on 7/10/25.
//

import Foundation
import RxSwift // RxSwift 추가

// MARK: - 도서 아이템 하나의 정보를 관리하는 ViewModel
class BookItemViewModel: ObservableObject, Identifiable {
    private let disposeBag = DisposeBag()
    @Published var book: BookItemModel // 책 모델
    
    private let favoriteRepository: FavoriteRepository // 즐겨찾기 책 데이터 처리 객체 주입
    @Published var isFavorite: Bool = false // 즐겨찾기 상태
    
    var deleteItem: (_ isbn: String) -> Void

    // MARK: - BookItemViewModel 초기화
    /// - Parameters:
    ///   - book: 도서 모델
    ///   - favoriteRepository: 즐겨찾기 데이터 관리를 위한 Repository
    ///   - deleteItem: 즐겨찾기 목록에서 아이템이 삭제되었을 때 호출될 클로저
    init(
        book: BookItemModel,
        favoriteRepository: FavoriteRepository,
        deleteItem: @escaping (_ isbn: String) -> Void
    ) {
        self.book = book
        self.favoriteRepository = favoriteRepository
        self.deleteItem = deleteItem
        checkFavoriteStatus() // 즐겨찾기 상태 확인

        // 즐겨찾기 상태 변경 이벤트를 구독하여 UI 실시간 업데이트
        favoriteRepository.favoriteBooksChanged
            .subscribe(onNext: { [weak self] in
                self?.checkFavoriteStatus()
            })
            .disposed(by: disposeBag)
    }
}


// MARK: - BookItemViewModel: 외부에 표시될 속성 변수들
extension BookItemViewModel {
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
        !book.authors.isEmpty ? book.authors.joined(separator: ", ") : "작가 정보 없음"
    }
    
    var translatorsText: String {
        !book.translators.isEmpty ? book.translators.joined(separator: ", ") : "번역가 정보 없음"
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
    
    // 할인 유무 판단
    var isDiscounted: Bool {
        guard let price = book.price, let salePrice = book.salePrice else { return false }
        return salePrice < price
    }
    
    var status: String {
        book.status ?? "정보 없음"
    }
    
    // 할인율 계산
    var discountPercentage: String {
        guard isDiscounted, let price = book.price, let salePrice = book.salePrice, price > 0 else { return "" }
        let percentage = (Double(price - salePrice) / Double(price)) * 100
        return String(format: "%.0f", percentage)
    }
    
    // 출판일 formatting
    var koreanFormattedPublishedDate: String {
        guard let date = book.datetime else { return "날짜 정보 없음" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        return dateFormatter.string(from: date)
    }
}


// MARK: - BookItemViewModel: 즐겨찾기 관련 로직
extension BookItemViewModel {
    
    /// 현재 도서의 즐겨찾기 상태를 확인하고 `isFavorite` 업데이트
    private func checkFavoriteStatus() {
        self.isFavorite = favoriteRepository.isBookFavorite(isbn: book.isbn)
    }
    
    /// 현재 도서의 즐겨찾기 상태 토글
    /// 즐겨찾기 추가/삭제 로직을 수행 / `isFavorite` 업데이트
    func toggleFavorite() {
        print("BookItemViewModel.toggleFavorite()", book.title)
        if isFavorite {
            deleteItem(book.isbn) // 즐겨찾기 목록 뷰에서 아이템 삭제를 알림
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

// MARK: - BookItemViewModel: Equatable
/// `BookItemViewModel`이 `Equatable` 프로토콜을 준수하도록 확장
/// 두 `BookItemViewModel` 인스턴스가 동일한 `book.id`를 가질 경우 같다고 판단
extension BookItemViewModel: Equatable {
    static func == (lhs: BookItemViewModel, rhs: BookItemViewModel) -> Bool {
        return lhs.book.id == rhs.book.id
    }
}
