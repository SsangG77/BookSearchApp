//
//  Meta.swift
//  BookSearchApp
//
//  Created by 차상진 on 7/15/25.
//

import Foundation

//MARK: - Meta 데이터
struct Meta: Decodable, Hashable {
    let isEnd: Bool         // 마지막 목록인지 유무
    let pageableCount: Int  // 노출 가능 문서 수
    let totalCount: Int     // 검색된 문서 수
}
