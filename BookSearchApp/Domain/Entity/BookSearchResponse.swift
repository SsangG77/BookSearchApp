//
//  BookSearchResponse.swift
//  BookSearchApp
//
//  Created by 차상진 on 7/15/25.
//

import Foundation

// MARK: - API 응답 모델
struct BookSearchResponse: Decodable, Hashable {
    let meta: Meta                   // 메타 데이터
    let documents: [BookItemModel]   // 도서 목록
}
