
//
//  BookItemModel.swift
//  BookSearchApp
//
//  Created by 차상진 on 7/10/25.
//

import Foundation

// MARK: - 책 아이템 모델
struct BookItemModel: Identifiable, Codable, Hashable {
    var id = UUID()
    let title: String         // 책 제목
    let contents: String?     // 책 소개글
    let url: String?          // 웹 검색 url
    let isbn: String          // 도서 ISBN
    let authors: [String]     // 작가 배열
    let publisher: String?    // 출판사
    let translators: [String] // 번역가
    let price: Int?           // 원 가격
    let salePrice: Int?       // 할인 가격
    let thumbnail: String?    // 표지 이미지 url
    let status: String?       // 도서 상태
    let datetime: Date?       // 출판일

    // API 응답 키와 모델 속성 이름이 다르면 변환
    enum CodingKeys: String, CodingKey {
        case title, contents, url, isbn, authors, publisher, translators, price, salePrice, thumbnail, status, datetime
    }
}

