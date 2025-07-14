//
//  BookItemModel+Ext.swift
//  BookSearchAppTests
//
//  Created by 차상진 on 7/14/25.
//

import Foundation
@testable import BookSearchApp

extension BookItemModel {
    static func mock(
        id: UUID = UUID(),
        title: String = "미움받을 용기",
        contents: String? = "이것은 샘플 책의 내용입니다.",
        url: String? = "https://search.daum.net/search?w=bookpage&bookId=1467038&q=%EB%AF%B8%EC%9B%80%EB%B0%9B%EC%9D%84+%EC%9A%A9%EA%B8%B0",
        isbn: String = UUID().uuidString, // 고유한 값을 위해 UUID 사용
        authors: [String] = ["샘플 저자"],
        publisher: String? = "샘플 출판사",
        translators: [String] = [],
        price: Int? = 15000,
        salePrice: Int? = 13500,
        thumbnail: String? = "https://search1.kakaocdn.net/thumb/R120x174.q85/?fname=http%3A%2F%2Ft1.daumcdn.net%2Flbook%2Fimage%2F1467038",
        status: String? = "정상판매",
        datetime: Date? = Date()
    ) -> BookItemModel {
        return BookItemModel(
            id: id,
            title: title,
            contents: contents,
            url: url,
            isbn: isbn,
            authors: authors,
            publisher: publisher,
            translators: translators,
            price: price,
            salePrice: salePrice,
            thumbnail: thumbnail,
            status: status,
            datetime: datetime
        )
    }
}
