
//
//  BookItemModel.swift
//  BookSearchApp
//
//  Created by 차상진 on 7/10/25.
//

import Foundation

// MARK: - API 응답 모델
// 중요: 이 모델을 디코딩하는 JSONDecoder는 반드시 다음 두 가지 전략을 설정해야 합니다.
// 1. decoder.keyDecodingStrategy = .convertFromSnakeCase
// 2. decoder.dateDecodingStrategy = .iso8601
struct BookSearchResponse: Decodable, Hashable {
    let meta: Meta
    let documents: [BookItemModel]
}

//MARK: - Meta 데이터
struct Meta: Decodable, Hashable {
    let isEnd: Bool
    let pageableCount: Int
    let totalCount: Int
}

// MARK: - 책 아이템 모델
struct BookItemModel: Identifiable, Codable, Hashable {
    var id = UUID()
    let title: String
    let contents: String?
    let url: String?
    let isbn: String
    let authors: [String]
    let publisher: String?
    let translators: [String]
    let price: Int?
    let salePrice: Int?
    let thumbnail: String?
    let status: String?
    let datetime: Date?

    // API 응답 키와 모델 속성 이름이 다르면 변환
    enum CodingKeys: String, CodingKey {
        case title, contents, url, isbn, authors, publisher, translators, price, salePrice, thumbnail, status, datetime
    }
}

