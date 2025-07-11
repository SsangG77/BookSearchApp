//
//  BookItemViewModel.swift
//  BookSearchApp
//
//  Created by 차상진 on 7/10/25.
//

import Foundation

// MARK: - Presentation Layer (ViewModel)
struct BookItemViewModel {
    private let book: BookItemModel

    init(book: BookItemModel) {
        self.book = book
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
        URL(string: book.thumbnail)
    }

    var publisher: String {
        book.publisher
    }

    var originalPrice: Int {
        book.price > 0 ? book.price : 0
    }

    var salePrice: Int {
        book.salePrice > 0 ? book.salePrice : 0
    }

    var isDiscounted: Bool {
        book.salePrice < book.price
    }
    
    var status: String {
        book.status == "" ? "정보 없음" : book.status
    }

    var discountPercentage: String {
        guard isDiscounted else { return "" }
        let percentage = (Double(book.price - book.salePrice) / Double(book.price)) * 100
        return String(format: "%.1f", percentage)
    }
    
    var publishedDateText: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        return dateFormatter.string(from: book.datetime)
    }
}
